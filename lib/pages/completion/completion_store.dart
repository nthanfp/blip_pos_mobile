import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompletionStore extends StatefulWidget {
  const CompletionStore({Key? key}) : super(key: key);

  @override
  _CompletionStoreState createState() => _CompletionStoreState();
}

class _CompletionStoreState extends State<CompletionStore> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();

  // Dropdown data
  List _provinces = [];
  List _cities = [];
  List _districts = [];
  List _villages = [];

  // Selected values
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedVillage;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  // Fungsi untuk memuat data provinsi
  Future<void> _fetchProvinces() async {
    final response = await http.get(Uri.parse('https://pos.theaxe.online/api/region/provinces'));
    if (response.statusCode == 200) {
      setState(() {
        _provinces = jsonDecode(response.body)['data'];
      });
    }
  }

  // Fungsi untuk memuat data kota
  Future<void> _fetchCities(String provinceId) async {
    setState(() {
      _cities = [];
      _districts = [];
      _villages = [];
      _selectedCity = null;
      _selectedDistrict = null;
      _selectedVillage = null;
    });
    final response = await http.get(Uri.parse('https://pos.theaxe.online/api/region/regencies/$provinceId'));
    if (response.statusCode == 200) {
      setState(() {
        _cities = jsonDecode(response.body)['data'];
      });
    }
  }

  // Fungsi untuk memuat data kecamatan
  Future<void> _fetchDistricts(String cityId) async {
    setState(() {
      _districts = [];
      _villages = [];
      _selectedDistrict = null;
      _selectedVillage = null;
    });
    final response = await http.get(Uri.parse('https://pos.theaxe.online/api/region/districts/$cityId'));
    if (response.statusCode == 200) {
      setState(() {
        _districts = jsonDecode(response.body)['data'];
      });
    }
  }

  // Fungsi untuk memuat data desa
  Future<void> _fetchVillages(String districtId) async {
    setState(() {
      _villages = [];
      _selectedVillage = null;
    });
    final response = await http.get(Uri.parse('https://pos.theaxe.online/api/region/villages/$districtId'));
    if (response.statusCode == 200) {
      setState(() {
        _villages = jsonDecode(response.body)['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lengkapi Profil Toko', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0060B8)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_storeNameController, 'Nama Toko'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email Toko', type: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_phoneController, 'Nomor Telepon', type: TextInputType.phone),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Provinsi',
                  items: _provinces,
                  value: _selectedProvince,
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                    });
                    _fetchCities(value!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Kota/Kabupaten',
                  items: _cities,
                  value: _selectedCity,
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                    _fetchDistricts(value!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Kecamatan',
                  items: _districts,
                  value: _selectedDistrict,
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                    _fetchVillages(value!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Kelurahan/Desa',
                  items: _villages,
                  value: _selectedVillage,
                  onChanged: (value) {
                    setState(() {
                      _selectedVillage = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(_postalController, 'Kode Pos', type: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_fullAddressController, 'Alamat Lengkap', maxLines: 3),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveStore,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required List items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item['id'].toString(),
              child: Text(item['name']),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _saveStore() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data toko berhasil disimpan!')),
      );
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _postalController.dispose();
    _fullAddressController.dispose();
    super.dispose();
  }
}
