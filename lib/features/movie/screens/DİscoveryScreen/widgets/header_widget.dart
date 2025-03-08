import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingHeader(theme);
        }

        final user = snapshot.data;
        if (user == null) {
          return _buildDefaultHeader(theme);
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingHeader(theme);
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return _buildDefaultHeader(theme);
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>?;
            final userName = (userData?['firstName'] as String? ?? 'Kullanıcı').toUpperCase();
            final photoUrl = userData?['photoUrl'] as String?;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Merhaba,",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? Icon(Icons.person, color: theme.colorScheme.onSurface)
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDefaultHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Merhaba,",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Film Sever",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
          child: Icon(Icons.person, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildLoadingHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
        ),
      ],
    );
  }
}
