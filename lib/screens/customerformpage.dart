import 'package:ecommerce_int2/screens/dbmain.dart';
import 'package:ecommerce_int2/screens/main/main_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:flutter/material.dart';

class CustomerFormPage extends StatefulWidget {
  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
  
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  @override
void initState() {
  super.initState();
  _loadExistingCustomer(); // prefill if a row exists
}

Future<void> _loadExistingCustomer() async {
  try {
    final row = await Dbmain.getLastInsertedCustomer(); // returns Map? or null
    if (row == null) return;

    String _str(dynamic v) => (v ?? '').toString();

    // Map DB columns -> your text controllers (only set if non-empty)
    final first = _str(row['bill_first_name']);
    if (first.isNotEmpty) _firstNameController.text = first;

    final last = _str(row['bill_last_name']);
    if (last.isNotEmpty) _lastNameController.text = last;

    final addr1 = _str(row['bill_street_add1']);
    if (addr1.isNotEmpty) _addressController.text = addr1;

    final dob = _str(row['dob']);
    if (dob.isNotEmpty) _dobController.text = dob;

    final h = _str(row['height']);
    if (h.isNotEmpty) _heightController.text = h;

    final w = _str(row['weight']);
    if (w.isNotEmpty) _weightController.text = w;

    final phone = _str(row['bill_phone']);
    if (phone.isNotEmpty) _phoneController.text = phone;

    final email = _str(row['bill_email_id']);
    if (email.isNotEmpty) _emailController.text = email;

    // gender (keep your default "Male" if empty/unknown)
    final g = _str(row['gender']).trim();
    if (g == 'Male' || g == 'Female') {
      setState(() => _gender = g);
    }
  } catch (_) {
    // swallow any errors silently (no crashes if empty/missing table/columns)
  }
}

  
  
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _gender = "Male";

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final customerData = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "address": _addressController.text,
        "dob": _dobController.text,
        "age": _ageController.text,
        "height": _heightController.text,
        "weight": _weightController.text,
        "gender": _gender,
        "phone": _phoneController.text,
        "email": _emailController.text,
      };

      // print("Submitting: $customerData");
      final id = await Dbmain.insertCustomerFromForm(form: customerData);

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      IconData? icon,
      String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            label: Text("Male"),
            selected: _gender == "Male",
            onSelected: (selected) {
              setState(() => _gender = "Male");
            },
            selectedColor: Colors.teal,
            labelStyle: TextStyle(
              color: _gender == "Male" ? Colors.white : Colors.black,
            ),
          ),
          ChoiceChip(
            label: Text("Female"),
            selected: _gender == "Female",
            onSelected: (selected) {
              setState(() => _gender = "Female");
            },
            selectedColor: Colors.teal,
            labelStyle: TextStyle(
              color: _gender == "Female" ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Customer Form"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _firstNameController,
                        label: "First Name",
                        icon: Icons.person,
                        validator: (val) =>
                            val!.isEmpty ? "Enter first name" : null,
                      ),
                      _buildTextField(
                        controller: _lastNameController,
                        label: "Last Name",
                        icon: Icons.person_outline,
                      ),
                      _buildTextField(
                        controller: _addressController,
                        label: "Address",
                        icon: Icons.home,
                      ),
                      _buildTextField(
                        controller: _dobController,
                        label: "Date of Birth",
                        icon: Icons.calendar_today,
                      ),
                      _buildTextField(
                        controller: _ageController,
                        label: "Age",
                        icon: Icons.cake,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _heightController,
                              label: "Height",
                              icon: Icons.height,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _weightController,
                              label: "Weight",
                              icon: Icons.monitor_weight,
                            ),
                          ),
                        ],
                      ),
                      _buildGenderSelector(),
                      _buildTextField(
                        controller: _phoneController,
                        label: "Phone",
                        icon: Icons.phone,
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
