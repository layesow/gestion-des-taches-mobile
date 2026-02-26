import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {

  // États des notifications (plus tard on sauvegardera dans les préférences)
  bool _allNotifications = true;
  bool _taskReminders = true;
  bool _taskDeadlines = true;
  bool _newFeatures = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          const SizedBox(height: 16),

          // Activer toutes les notifications
          Container(
            color: Colors.white,
            child: SwitchListTile(
              title: const Text(
                'Activer les notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              subtitle: const Text(
                'Recevoir toutes les notifications',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
              value: _allNotifications,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _allNotifications = value;
                  if (!value) {
                    _taskReminders = false;
                    _taskDeadlines = false;
                    _newFeatures = false;
                  }
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Types de notifications
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Types de notifications',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Rappels de tâches',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Notifications 1h avant l\'échéance',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  value: _taskReminders && _allNotifications,
                  activeColor: AppColors.primary,
                  onChanged: _allNotifications ? (value) {
                    setState(() {
                      _taskReminders = value;
                    });
                  } : null,
                ),

                const Divider(),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Échéances proches',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Tâches à faire aujourd\'hui',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  value: _taskDeadlines && _allNotifications,
                  activeColor: AppColors.primary,
                  onChanged: _allNotifications ? (value) {
                    setState(() {
                      _taskDeadlines = value;
                    });
                  } : null,
                ),

                const Divider(),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Nouvelles fonctionnalités',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Mises à jour et nouveautés',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  value: _newFeatures && _allNotifications,
                  activeColor: AppColors.primary,
                  onChanged: _allNotifications ? (value) {
                    setState(() {
                      _newFeatures = value;
                    });
                  } : null,
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}