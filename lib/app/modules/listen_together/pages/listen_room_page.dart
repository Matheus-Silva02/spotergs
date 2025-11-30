import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/listen_together/controllers/listen_controller.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class ListenRoomPage extends GetView<ListenController> {
  const ListenRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = Get.parameters['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ouvir Juntos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Obx(() {
                return Text(
                  '${controller.participants.length} pessoas',
                  style: const TextStyle(fontSize: 14),
                );
              }),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isConnected.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Conectando à sala...'),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Current track info
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Room info
                      Card(
                        color: AppTheme.surfaceColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sala: $roomId',
                                style: AppTextStyles.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Obx(() {
                                return Text(
                                  'Status: ${controller.isConnected.value ? 'Conectado' : 'Desconectado'}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: controller.isConnected.value
                                        ? AppTheme.primaryColor
                                        : AppTheme.errorColor,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Participants list
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Participantes:',
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.participants.length,
                          itemBuilder: (context, index) {
                            final participant = controller.participants[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppTheme.primaryColor,
                                      child: Text(
                                        (participant['nickname'] as String)
                                            .substring(0, 1)
                                            .toUpperCase(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          participant['nickname'] ?? 'Desconhecido',
                                          style: AppTextStyles.titleMedium,
                                        ),
                                        Text(
                                          participant['joinedAt'] ?? '---',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppTheme.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (participant['isPlaying'] == true)
                                      const Icon(
                                        Icons.play_circle,
                                        color: AppTheme.primaryColor,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Sair da Sala'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
