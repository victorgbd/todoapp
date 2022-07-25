import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todoapp/views/todo_notifier_provider.dart';

import '../data/model/todo_model.dart';
import 'loading_notifier.dart';

class NewTodo extends ConsumerStatefulWidget {
  const NewTodo({Key? key}) : super(key: key);

  @override
  ConsumerState<NewTodo> createState() => _NewTodoState();
}

final _formKey = GlobalKey<FormBuilderState>();

class _NewTodoState extends ConsumerState<NewTodo> {
  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(loadingNotifierProvider, (_, isLoading) {
      isLoading ? context.loaderOverlay.show() : context.loaderOverlay.hide();
    });
    final screenSize = MediaQuery.of(context).size;

    Future<void> save() async {
      final result = _formKey.currentState?.saveAndValidate() ?? false;
      if (!result) return;
      final content = _formKey.currentState?.value['content'] as String;
      final notifier = ref.read(todoNotifierProvider.notifier);

      notifier.create(TodoModel()
        ..content = content
        ..date = DateTime.now().toString()
        ..isComplete = 'false');
      _formKey.currentState?.reset();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Crear nueva actividad')),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: 'Nueva Actividad',
                  ),
                  name: 'content',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.06,
                  child: ElevatedButton.icon(
                    onPressed: save,
                    icon: Container(),
                    label: const Text("Guardar"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
