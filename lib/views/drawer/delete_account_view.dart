import 'package:provider/provider.dart';
import 'package:theinstallers/model/delete_reason_model.dart';

import '../../../utils/exports.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../widgets/custom_label.dart';
import '../authentication/login_view.dart';


class DeleteAccountView extends StatefulWidget {
  
  DeleteAccountView({super.key, });
  
  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _others = TextEditingController();

   @override
  void dispose() {
    _reason.dispose();
   _others.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       final bookingProviderVisible =
        Provider.of<BookingControllerProvider>(context);
    return  Scaffold(
   appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.deleteAccountRequest,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
               const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomLabel(text: Labels.deleteReason)),
                ),
                Form(
                  child: Consumer<BookingControllerProvider>(
                      builder: (context, bookingProvider, _) {
                    return FutureBuilder<DeleteReasonModel?>(
                      future: bookingProvider.fetchDeleteRason(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('No data available');
                        } else {
                          final deleteReasonList = snapshot.data!.items;

                          if (bookingProviderVisible.selectedReasonListId ==
                              null) {
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors
                                      .red, // Set the border color to red to highlight the error
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                style: AppTextStyle.textBoxInputStyle,
                                hint: const Text("Select Delete Reason: "),
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: bookingProvider.selectedReasonListId,
                                items: deleteReasonList!.map((reasonListData) {
                                  return DropdownMenuItem<int>(
                                    value: reasonListData.id,
                                    child: Text(reasonListData.reasonList ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newReasonListId) async {
                                  bookingProvider
                                      .setSelectedReasonListId(newReasonListId);
                                  _reason.text = newReasonListId.toString();
                                },
                              ),
                            );
                          } else {
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.dropdownBorderColor,
                                    width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                style: AppTextStyle.textBoxInputStyle,
                                hint: const Text("Select Delete Reason: "),
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: bookingProvider.selectedReasonListId,
                                items: deleteReasonList!.map((reasonListData) {
                                  return DropdownMenuItem<int>(
                                    value: reasonListData.id,
                                    child: Text(reasonListData.reasonList ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newReasonListId) async {
                                  bookingProvider
                                      .setSelectedReasonListId(newReasonListId);
                                  _reason.text = newReasonListId.toString();
                                },
                              ),
                            );
                          }
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                   visible: bookingProviderVisible.selectedReasonListId == 6 ? true : false,
                  child: AppTextFormField(
                    labelText: Labels.other,
                    controller: _others,
                    hintText: Labels.typeHere,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                Consumer<BookingControllerProvider>(
                builder: (context, book, child) {
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (book.responseMessage != '') {
                            showMessage(
                                message: book.responseMessage, context: context);
                            book.clear();
                          }
                        });
          
                  return customButton(
                    text: Labels.deleteMyAccountNow.toUpperCase(),
                    
                       ontap: () async {
                      if (_formKey.currentState!.validate()) {
          
                          try {
                       
                           await  book.deleteAccountRequest(
                          reason: _reason.text.trim(),  
                          others: _others.text.trim(),
                          
                              onSuccess: () {
                              // Clear the text form field values here
                              _reason.clear();
                              _others.clear();

                              DatabaseControllerProvider().logOut();
                        // ignore: use_build_context_synchronously
                        PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
                              
                            },
                         
                          );
                           
                        
                          
                          } catch (e) {
                            AppErrorSnackBar(context).error(e);
                          }
          
         
                      }
                    },
              
                  context: context,
                  status: book.isLoading,
              
                  );
                }
              ),   

                
              ],
            ),
            
          ),
          
        ),
      
      ),
    );
  }
}