import 'package:flutter/material.dart';
import 'package:virtual_home_demo/data/demo_home_data.dart';
import 'package:virtual_home_demo/screens/home_screen.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';
import 'package:virtual_home_demo/widgets/room_view.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.blue,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 11),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'home smart',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.ink,
                                ),
                              ),
                              Text(
                                'A HOME FOR EVERY POSSIBILITY',
                                style: TextStyle(
                                  fontSize: 8,
                                  letterSpacing: 1.1,
                                  color: AppTheme.mutedInk,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.wb_sunny_outlined,
                            color: AppTheme.ink,
                            size: 21,
                          ),
                        ],
                      ),
                      const SizedBox(height: 23),
                      SizedBox(
                        height: 325,
                        width: double.infinity,
                        child: RoomView(
                          room: demoRooms.first,
                          devices: demoDevices
                              .where((device) => device.roomId == initialRoomId)
                              .toList(),
                          brightness: 0.56,
                          ambientColor: const Color(0xFFFFD29A),
                          blindPosition: 0.64,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'A smarter home\nstarts with a feeling.',
                        style: TextStyle(
                          color: AppTheme.ink,
                          height: 1.08,
                          fontSize: 37,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Turn on the lights. Set the mood. Make yourself at home — all from this little preview.',
                        style: TextStyle(
                          color: AppTheme.mutedInk,
                          fontSize: 15,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 57,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.explore_outlined, size: 20),
                          label: const Text('Explore IKEA Home smart'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'NO HUB NEEDED · NO DEVICES NEEDED · JUST EXPLORE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.mutedInk,
                            fontSize: 9,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
