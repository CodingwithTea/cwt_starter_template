const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { getFirestore, serverTimestamp } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const admin = require('firebase-admin');

const firestore = getFirestore();
const messaging = getMessaging();

const NOTIFICATIONS_COLLECTION = 'Notifications';
const ATTEMPTS_COLLECTION = 'NotificationAttempts';
const USERS_COLLECTION = 'Users';

exports.sendNotifications = onDocumentCreated(
    `${NOTIFICATIONS_COLLECTION}/{notificationId}`,
    async (event) => {
        const notificationData = event.data?.data();
        const notificationId = event.params.notificationId;

        if (!notificationData || !notificationData.recipientIds || !Array.isArray(notificationData.recipientIds)) {
            console.error('Invalid notification data:', notificationData);
            return;
        }

        const attemptRef = firestore.collection(ATTEMPTS_COLLECTION).doc(notificationId);

        try {
            // Check for existing attempt
            const attemptDoc = await attemptRef.get();
            if (attemptDoc.exists && attemptDoc.data().status === 'completed') {
                console.log(`Notification ${notificationId} already processed, skipping.`);
                return;
            }

            const batch = firestore.batch();

            // Initialize or update attempt
            batch.set(
                attemptRef,
                {
                    notificationId,
                    recipientIds: notificationData.recipientIds,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    status: 'pending',
                    notificationSent: {},
                },
                { merge: true }
            );

            // Fetch recipient tokens
            const tokensData = await fetchRecipientTokens(notificationData.recipientIds, attemptDoc);
            if (tokensData.length === 0) {
                console.log('No valid tokens found or all recipients already notified.');
                batch.update(attemptRef, { status: 'failed', reason: 'No valid tokens or all recipients already notified' });
                await batch.commit();
                return;
            }

            // Send notifications
            const responses = await sendNotificationsToRecipients(tokensData, notificationData, attemptRef, batch);
            if (responses.every((resp) => resp.status === 'success')) {
                batch.update(event.data.ref, {
                    isSent: true,
                    sentAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }

            // Finalize attempt record
            batch.update(attemptRef, {
                status: 'completed',
                responses,
            });

            await batch.commit();
            console.log('Notification attempt successfully committed.');

        } catch (error) {
            console.error('Error sending notifications:', error);
            await attemptRef.set(
                { status: 'failed', reason: JSON.stringify(error) },
                { merge: true }
            );
        }
    }
);

/**
 * Fetch recipient tokens from Firestore.
 */
async function fetchRecipientTokens(recipientIds, attemptDoc) {
    const promises = recipientIds.map(async (userId) => {
        if (attemptDoc.exists && attemptDoc.data().notificationSent[userId]) {
            console.log(`User ${userId} already notified, skipping.`);
            return null;
        }

        const userDoc = await firestore.collection(USERS_COLLECTION).doc(userId).get();
        const userData = userDoc.data();
        if (!userData || !userData.deviceToken) {
            console.warn(`No device token found for user ${userId}, skipping.`);
            return null;
        }
        return { token: userData.deviceToken, userId };
    });

    const results = await Promise.all(promises);
    return results.filter((result) => result !== null);
}

/**
 * Send notifications to recipients and track status.
 */
async function sendNotificationsToRecipients(tokensData, notificationData, attemptRef, batch) {
    const message = {
        notification: {
            title: notificationData.title,
            body: notificationData.body,
        },
        data: {
            id: notificationData.routeId || attemptRef.id,
            route: notificationData.route,
        },
    };

    const promises = tokensData.map(async ({ token, userId }) => {
        try {
            await messaging.send({
                token,
                ...message,
            });
            console.log(`Notification sent to user ${userId}`);
            batch.update(attemptRef, { [`notificationSent.${userId}`]: true });
            return { userId, status: 'success' };
        } catch (error) {
            console.error(`Error sending notification to user ${userId}:`, error);
            return { userId, status: 'failed', error: JSON.stringify(error) };
        }
    });

    return Promise.all(promises);
}
