import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/service_log.dart';
import '../../models/log_aktivitas_model.dart';

class LogAktivitasScreen extends StatefulWidget {
  const LogAktivitasScreen({super.key});

  @override
  State<LogAktivitasScreen> createState() => _LogAktivitasScreenState();
}

class _LogAktivitasScreenState extends State<LogAktivitasScreen> {
  final ServiceLog _serviceLog = ServiceLog();
  String _searchQuery = '';
  List<LogAktivitasModel> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    final logs = await _serviceLog.getAllLogs();
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _logs.where((log) {
      final query = _searchQuery.toLowerCase();
      return log.namaUser.toLowerCase().contains(query) ||
          log.aktivitas.toLowerCase().contains(query);
    }).toList();

    return Container(
      color: const Color(0xFFFFF8E1),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log Aktivitas',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Search bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),

          // List log
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchLogs,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredLogs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_toggle_off,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada aktivitas yang ditemukan',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: filteredLogs.length,
                          itemBuilder: (context, index) {
                            final log = filteredLogs[index];
                            final dateFormat =
                                DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
                            final formattedDate = dateFormat.format(log.waktu);

                            final isSystem = log.idUser == null;

                            IconData icon;
                            Color iconColor;

                            if (log.aktivitas.toLowerCase().contains('login')) {
                              icon = Icons.login;
                              iconColor = Colors.green;
                            } else if (log.aktivitas
                                    .toLowerCase()
                                    .contains('approve') ||
                                log.aktivitas
                                    .toLowerCase()
                                    .contains('menyetujui')) {
                              icon = Icons.check_circle;
                              iconColor = Colors.blue;
                            } else if (log.aktivitas
                                    .toLowerCase()
                                    .contains('tolak') ||
                                log.aktivitas
                                    .toLowerCase()
                                    .contains('menolak')) {
                              icon = Icons.cancel;
                              iconColor = Colors.red;
                            } else {
                              icon = Icons.history;
                              iconColor = Colors.orange;
                            }

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.1),
                                  child: Icon(icon, color: iconColor, size: 20),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      log.namaUser,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    if (isSystem) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text('SYSTEM',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                      ),
                                    ]
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(log.aktivitas,
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
