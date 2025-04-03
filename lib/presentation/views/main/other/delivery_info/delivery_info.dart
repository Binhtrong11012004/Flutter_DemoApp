import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../core/constant/images.dart';
import '../../../../../data/models/user/delivery_info_model.dart';
import '../../../../../domain/entities/user/delivery_info.dart';
import '../../../../blocs/delivery_info/delivery_info_action/delivery_info_action_cubit.dart';
import '../../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../../widgets/delivery_info_card.dart';
import '../../../../widgets/input_form_button.dart';
import '../../../../widgets/input_text_form_field.dart';

class DeliveryInfoView extends StatefulWidget {
  const DeliveryInfoView({super.key});

  @override
  State<DeliveryInfoView> createState() => _DeliveryInfoViewState();
}

class _DeliveryInfoViewState extends State<DeliveryInfoView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryInfoActionCubit, DeliveryInfoActionState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is DeliveryInfoActionLoading) {
          EasyLoading.show(status: 'Đang Tải...');
        } else if (state is DeliveryInfoSelectActionSuccess) {
          context
              .read<DeliveryInfoFetchCubit>()
              .selectDeliveryInfo(state.deliveryInfo);
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError("Lỗi");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin giao hàng"),
        ),
        body: BlocBuilder<DeliveryInfoFetchCubit, DeliveryInfoFetchState>(
          builder: (context, state) {
            if(state is! DeliveryInfoFetchLoading && state.deliveryInformation.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kEmptyDeliveryInfo),
                  const Text("Thông tin giao hàng đang trống!"),
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              );
            }
            return ListView.builder(
              itemCount: (state is DeliveryInfoFetchLoading &&
                      state.deliveryInformation.isEmpty)
                  ? 5
                  : state.deliveryInformation.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) =>
                  (state is DeliveryInfoFetchLoading &&
                          state.deliveryInformation.isEmpty)
                      ? const DeliveryInfoCard()
                      : DeliveryInfoCard(
                          deliveryInformation: state.deliveryInformation[index],
                          isSelected: state.deliveryInformation[index] ==
                              state.selectedDeliveryInformation,
                        ),
            );
          },
        ),
        floatingActionButton: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  builder: (BuildContext context) {
                    return const DeliveryInfoForm();
                  },
                );
              },
              tooltip: 'Tăng',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryInfoForm extends StatefulWidget {
  final DeliveryInfo? deliveryInfo;
  const DeliveryInfoForm({
    super.key,
    this.deliveryInfo,
  });

  @override
  State<DeliveryInfoForm> createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
  String? id;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController addressLineOne = TextEditingController();
  final TextEditingController addressLineTwo = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.deliveryInfo != null) {
      id = widget.deliveryInfo!.id;
      firstName.text = widget.deliveryInfo!.firstName;
      lastName.text = widget.deliveryInfo!.lastName;
      addressLineOne.text = widget.deliveryInfo!.addressLineOne;
      addressLineTwo.text = widget.deliveryInfo!.addressLineTwo;
      city.text = widget.deliveryInfo!.city;
      zipCode.text = widget.deliveryInfo!.zipCode;
      contactNumber.text = widget.deliveryInfo!.contactNumber;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryInfoActionCubit, DeliveryInfoActionState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is DeliveryInfoActionLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is DeliveryInfoAddActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .addDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess("Thông tin giao hàng được thêm thành công!");
        } else if (state is DeliveryInfoEditActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .editDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess("Thông tinh giao hàng được chỉnh sửa thành công!");
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError("Lỗi");
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  InputTextFormField(
                    controller: firstName,
                    hint: 'Tên',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: lastName,
                    hint: 'Họ',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: addressLineOne,
                    hint: 'Địa chỉ 1',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: addressLineTwo,
                    hint: 'Địa chỉ 2',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: city,
                    hint: 'Thành phố',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: zipCode,
                    hint: 'Mã Zip',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: contactNumber,
                    hint: 'Số điện thoại liên hệ',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'Ô này không được trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.deliveryInfo == null) {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .addDeliveryInfo(DeliveryInfoModel(
                                id: '',
                                firstName: firstName.text,
                                lastName: lastName.text,
                                addressLineOne: addressLineOne.text,
                                addressLineTwo: addressLineTwo.text,
                                city: city.text,
                                zipCode: zipCode.text,
                                contactNumber: contactNumber.text,
                              ));
                        } else {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .editDeliveryInfo(DeliveryInfoModel(
                                id: id!,
                                firstName: firstName.text,
                                lastName: lastName.text,
                                addressLineOne: addressLineOne.text,
                                addressLineTwo: addressLineTwo.text,
                                city: city.text,
                                zipCode: zipCode.text,
                                contactNumber: contactNumber.text,
                              ));
                        }
                      }
                    },
                    titleText: widget.deliveryInfo == null ? 'Lưu' : 'Cập nhật',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    titleText: 'Huỷ',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
