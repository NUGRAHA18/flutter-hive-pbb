import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final Box _box = Hive.box('mahasiswaBox');

  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _prodiController = TextEditingController();
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? _editIndex;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nama': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'prodi': _prodiController.text.trim(),
    };

    if (_editIndex == null) {
      _box.add(data);
      _showSnackBar('Mahasiswa berhasil ditambahkan');
    } else {
      _box.putAt(_editIndex!, data);
      _showSnackBar('Data mahasiswa berhasil diperbarui');
    }

    _resetForm();
  }

  void _edit(int index) {
    final data = _box.getAt(index);
    setState(() {
      _editIndex = index;
      _namaController.text = data['nama'];
      _nimController.text = data['nim'];
      _prodiController.text = data['prodi'];
    });
  }

  Future<void> _hapus(int index) async {
    final data = _box.getAt(index);
    final nama = data['nama'] as String;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Mahasiswa'),
        content: Text(
          'Yakin ingin menghapus data "$nama"?\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _box.deleteAt(index);
      _showSnackBar('Data "$nama" berhasil dihapus');
    }
  }

  void _resetForm() {
    _namaController.clear();
    _nimController.clear();
    _prodiController.clear();
    setState(() => _editIndex = null);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getInitials(String nama) {
    final parts = nama.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nama.isNotEmpty ? nama[0].toUpperCase() : '?';
  }

  Color _getAvatarColor(String nama) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final index = nama.isNotEmpty ? nama.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text(
          'Data Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (context, Box box, _) => Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${box.length} mahasiswa',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Form section
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editIndex == null
                        ? 'Tambah Mahasiswa Baru'
                        : 'Edit Data Mahasiswa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Masukkan nama lengkap',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'Contoh: 23106050011',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'NIM tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _prodiController,
                    decoration: const InputDecoration(
                      labelText: 'Program Studi',
                      prefixIcon: Icon(Icons.school_outlined),
                      hintText: 'Contoh: Teknik Informatika',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Program studi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _simpan,
                          icon: Icon(
                            _editIndex == null
                                ? Icons.add
                                : Icons.save_outlined,
                          ),
                          label: Text(_editIndex == null ? 'Simpan' : 'Perbarui'),
                        ),
                      ),
                      if (_editIndex != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.close),
                            label: const Text('Batal'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama, NIM, atau prodi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),

          // List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (context, Box box, _) {
                // Build filtered list
                final allItems = List.generate(box.length, (i) {
                  final data = box.getAt(i) as Map;
                  return MapEntry(i, data);
                });

                final filtered = _searchQuery.isEmpty
                    ? allItems
                    : allItems.where((e) {
                        final d = e.value;
                        return (d['nama'] as String)
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            (d['nim'] as String)
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            (d['prodi'] as String)
                                .toLowerCase()
                                .contains(_searchQuery);
                      }).toList();

                // Header
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'Hasil pencarian (${filtered.length})'
                            : 'Daftar Mahasiswa (${box.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final entry = filtered[i];
                                final index = entry.key;
                                final data = entry.value;
                                return _buildCard(index, data);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.people_outline,
            size: 72,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Tidak ada hasil pencarian'
                : 'Belum ada data mahasiswa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Coba kata kunci yang berbeda'
                : 'Tambahkan mahasiswa menggunakan form di atas',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index, Map data) {
    final nama = data['nama'] as String;
    final nim = data['nim'] as String;
    final prodi = data['prodi'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: _getAvatarColor(nama),
          child: Text(
            _getInitials(nama),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.badge_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(nim, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.school_outlined,
                    size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    prodi,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              tooltip: 'Edit',
              onPressed: () => _edit(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Hapus',
              onPressed: () => _hapus(index),
            ),
          ],
        ),
      ),
    );
  }
}
