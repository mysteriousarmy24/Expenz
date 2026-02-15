import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddnewScreen extends StatefulWidget {
  final Function(Expense) addExpense;
  final Function(Income) addIncome;
  final double? preFillAmount;
  final String? preFillType; // "Expense" or "Income"

  const AddnewScreen({
    super.key,
    required this.addExpense,
    required this.addIncome,
    this.preFillAmount,
    this.preFillType,
  });

  @override
  State<AddnewScreen> createState() => _AddnewScreenState();
}

class _AddnewScreenState extends State<AddnewScreen> {
  int _selectedMethod = 1;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  ExpenseCategory _expenseCategory = ExpenseCategory.health;
  IncomeCategory _incomeCategory = IncomeCategory.salary;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with pre-filled data if provided
    if (widget.preFillAmount != null) {
      _amountController.text = widget.preFillAmount.toString();
    }
    if (widget.preFillType != null) {
      _selectedMethod = widget.preFillType == "Expense" ? 0 : 1;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedMethod == 0 ? kRed : kGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(kDefalutPadding),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    color: kWhite,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMethod = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _selectedMethod == 0 ? kRed : kWhite,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 54,
                              vertical: 15,
                            ),
                            child: Text(
                              "Expense",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedMethod == 0
                                    ? kWhite
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMethod = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _selectedMethod == 1 ? kGreen : kWhite,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 54,
                              vertical: 15,
                            ),
                            child: Text(
                              "Income",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedMethod == 1
                                    ? kWhite
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefalutPadding,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How much?",
                        style: TextStyle(
                          color: kLightGrey.withOpacity(0.8),
                          fontSize: 20,
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          color: kWhite,
                        ),
                        decoration: InputDecoration(
                          hintText: "0",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //form
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3,
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          items: _selectedMethod == 0
                              ? ExpenseCategory.values.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList()
                              : IncomeCategory.values.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                          value: _selectedMethod == 0
                              ? _expenseCategory
                              : _incomeCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedMethod == 0
                                  ? _expenseCategory = value as ExpenseCategory
                                  : _incomeCategory = value as IncomeCategory;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter a title";
                            }
                          },
                          controller: _titleController,
                          decoration: InputDecoration(
                            hint: Text("Title"),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),

                        //description
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter a discription";
                            }
                          },
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hint: Text("Description"),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter a valid number...";
                            }
                            double amount = double.parse(value);
                            if (amount == null || amount <= 0) {
                              return "please enter a valid number...";
                            }
                          },
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hint: Text("Amount"),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  //initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2027),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedDate = value;
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: kMainColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 20,
                                        color: kWhite,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Select Date",
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(_selectedDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: kGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        //time
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedTime = DateTime(
                                        _selectedDate.year,
                                        _selectedDate.month,
                                        _selectedDate.day,
                                        value.hour,
                                        value.minute,
                                      );
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: kYellow,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        size: 20,
                                        color: kWhite,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Select Time",
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              DateFormat.jm().format(_selectedTime),
                              style: TextStyle(
                                fontSize: 15,
                                color: kGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(color: kGrey.withOpacity(0.3), thickness: 5),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedMethod == 0) {
                                //methode to save expenses as shared pref
                                List<Expense> loadedExpenses =
                                    await ExpenseService().loadExpense();
                                //create expense to store
                                Expense expense = Expense(
                                  id: loadedExpenses.length + 1,
                                  title: _titleController.text,
                                  amount: _amountController.text.isEmpty
                                      ? 0
                                      : double.parse(_amountController.text),
                                  category: _expenseCategory,
                                  date: _selectedDate,
                                  time: _selectedTime,
                                  description: _descriptionController.text,
                                );
                                //add expense
                                widget.addExpense(expense);

                                //clear the feilds
                                _amountController.clear();
                                _descriptionController.clear();
                                _titleController.clear();
                              } else {
                                //methode to save expenses as shared pref
                                List<Income> loadedIncomes =
                                    await IncomeServices().loadIncome();
                                //create income to store
                                Income income = Income(
                                  id: loadedIncomes.length + 1,
                                  title: _titleController.text,
                                  amount: _amountController.text.isEmpty
                                      ? 0
                                      : double.parse(_amountController.text),
                                  category: _incomeCategory,
                                  date: _selectedDate,
                                  time: _selectedTime,
                                  description: _descriptionController.text,
                                );
                                //add expense
                                widget.addIncome(income);

                                //clear the feilds
                                _amountController.clear();
                                _descriptionController.clear();
                                _titleController.clear();
                              }
                            }
                          },
                          child: CustomButton(
                            bgColor: _selectedMethod == 1 ? kGreen : kRed,
                            name: "Add",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
