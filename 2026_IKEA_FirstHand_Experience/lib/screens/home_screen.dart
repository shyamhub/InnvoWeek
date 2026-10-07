import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/room.dart';
import 'package:virtual_home_demo/screens/room_screen.dart';
import 'package:virtual_home_demo/state/smart_home_state.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';
import 'package:virtual_home_demo/widgets/room_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = SmartHomeScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(23, 19, 23, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      const _HomeMark(),
                      const SizedBox(width: 10),
                      const Text(
                        'home smart',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppTheme.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EEE1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              color: Color(0xFF527252),
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'PREVIEW MODE',
                              style: TextStyle(
                                color: Color(0xFF527252),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 39),
                  const Text(
                    'Your home,',
                    style: TextStyle(
                      fontSize: 36,
                      color: AppTheme.ink,
                      height: 1.06,
                    ),
                  ),
                  const Text(
                    'your kind of everyday.',
                    style: TextStyle(
                      fontSize: 36,
                      color: AppTheme.ink,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(height: 11),
                  const Text(
                    'Pick a room to see what a little smart can do.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedInk,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  for (final room in state.rooms) ...[
                    _RoomCard(
                      room: room,
                      onTap: () {
                        state.selectRoom(room.id);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const RoomScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                  const SizedBox(height: 7),
                  Material(
                    color: const Color(0xFFECE9E0),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF90794D),
                            size: 23,
                          ),
                          const SizedBox(width: 13),
                          const Expanded(
                            child: Text(
                              'Just exploring. Nothing in your real home will change.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.ink,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Center(
                    child: TextButton(
                      onPressed: () => _showSetupMessage(context),
                      child: const Text(
                        'Ready for a real smart home? Set yours up',
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showSetupMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your real home setup is the next step. This preview stays safely virtual.',
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.onTap});

  final Room room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = SmartHomeScope.of(context);
    final devices = state.devicesForRoom(room.id);
    return Material(
      color: AppTheme.paper,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 183,
                width: double.infinity,
                child: RoomView(
                  room: room,
                  devices: devices,
                  brightness: state.brightnessForRoom(room.id),
                  ambientColor: state.colorForRoom(room.id),
                  blindPosition: state.blindPositionForRoom(room.id),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 14, 3, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              color: AppTheme.ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${room.description}  ·  ${room.deviceCountLabel}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.mutedInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMark extends StatelessWidget {
  const _HomeMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
    );
  }
}
