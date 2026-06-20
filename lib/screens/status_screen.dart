import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import '../services/arm_me_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final ArmMeService _apiService = ArmMeService();

  bool _isLoading = true;
  bool _isAlarmActive = false;
  String? errorMessage;
  String? _token;

  @override
  void initState() {
    super.initState();
    _token = context.read<LoginProvider>().token;
    getAlarmStatus(_token ?? "");
  }

  Future<void> getAlarmStatus(String token) async {

    try {
      setState(() {
        _isLoading = true;
      });

      // Open alarm connection first
      await _apiService.openConnection(token);

      // Get current alarm status
      final status = await _apiService.getAlarmStatus(token);

      if (!mounted) return;

      setState(() {
        _isAlarmActive = status;
      });
    } catch (e) {
      debugPrint("The error encountered for loading alarm system: $e");
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Failed to fetch alarm status"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> updateAlarmStatus(String token) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _apiService.updateAlarmStatus(token);

      //  fetch  the status again to get get the updated one
      final updatedStatus = await _apiService.getAlarmStatus(token);

      if (!mounted) return;

      setState(() {
        _isAlarmActive = updatedStatus;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Alarm status has been successfully updated!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("the error encountered when updating alarm status: $e");

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Failed to arm the alarm"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _isAlarmActive ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ArmME",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            children: [
              const Text(
                "Alarm system status",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _isAlarmActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _isLoading ? null
                              : getAlarmStatus(_token ?? "");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red.shade900,
                          backgroundColor: Colors.white,
                            side: BorderSide(
                                color: Colors.red.shade900
                            )
                        ),
                        child: const Text(
                          "Refresh Status",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _isLoading ? null
                              : updateAlarmStatus(_token ?? "");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Arm Alarm",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
