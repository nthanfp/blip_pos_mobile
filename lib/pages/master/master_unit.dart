import 'package:blip_pos/service/master/units.dart';
import 'package:flutter/material.dart';

class MasterUnitPage extends StatefulWidget {
  const MasterUnitPage({Key? key}) : super(key: key);

  @override
  _MasterUnitPageState createState() => _MasterUnitPageState();
}

class _MasterUnitPageState extends State<MasterUnitPage> {
  List<Map<String, dynamic>> _units = [];

  @override
  void initState() {
    super.initState();
    _refreshUnits();
  }

  Future<void> _refreshUnits() async {
    try {
      final units = await UnitService().fetchUnits();
      setState(() {
        _units = units;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching units: $e')),
      );
    }
  }

  Future<void> _showAddUnitDialog() async {
    final unitNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Unit'),
        content: TextFormField(
          controller: unitNameController,
          decoration: const InputDecoration(labelText: 'Unit Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (unitNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a unit name.')),
                );
                return;
              }

              try {
                await UnitService().addUnit({
                  'unit_name': unitNameController.text,
                });
                _refreshUnits();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unit added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding unit: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditUnitDialog(Map<String, dynamic> unit) async {
    final unitNameController = TextEditingController(text: unit['unit_name']);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Unit'),
        content: TextFormField(
          controller: unitNameController,
          decoration: const InputDecoration(labelText: 'Unit Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (unitNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a unit name.')),
                );
                return;
              }

              try {
                await UnitService().updateUnit(unit['id'], {
                  'unit_name': unitNameController.text,
                });
                _refreshUnits();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unit updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating unit: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUnit(int unitId) async {
    try {
      await UnitService().deleteUnit(unitId);
      _refreshUnits();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting unit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Unit'),
      ),
      body: _units.isEmpty
          ? const Center(child: Text('No units found.'))
          : ListView.builder(
              itemCount: _units.length,
              itemBuilder: (ctx, index) {
                final unit = _units[index];

                return ListTile(
                  title: Text(unit['unit_name'] ?? 'No name'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditUnitDialog(unit),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteUnit(unit['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUnitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
