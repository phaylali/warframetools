import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ValidatedTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const ValidatedTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  bool _isValid = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    final text = widget.controller.text;

    if (text.isEmpty) {
      setState(() {
        _isValid = false;
        _hasError = false;
        _errorMessage = null;
      });
      return;
    }

    String? error;
    bool isValid = false;

    if (widget.validator != null) {
      error = widget.validator!(text);
      isValid = error == null;
    } else if (widget.keyboardType == TextInputType.emailAddress) {
      isValid = EmailValidator.validate(text);
      if (!isValid) {
        error = 'Please enter a valid email address';
      }
    } else if (widget.obscureText) {
      // Password validation
      if (text.length < 8) {
        error = 'Password must be at least 8 characters';
      } else if (text.length > 25) {
        error = 'Password must be 25 characters or less';
      } else {
        isValid = true;
      }
    } else {
      isValid = text.isNotEmpty;
    }

    setState(() {
      _isValid = isValid && text.isNotEmpty;
      _hasError = error != null;
      _errorMessage = error;
    });

    widget.onChanged?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: _buildValidationIcon(),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError
                    ? Theme.of(context).colorScheme.error
                    : _isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary,
                width: _isValid ? 2.0 : 1.0,
              ),
            ),
            errorText: _errorMessage,
            errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        if (widget.obscureText && widget.controller.text.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildPasswordStrengthIndicator(),
        ],
      ],
    );
  }

  Widget? _buildValidationIcon() {
    if (widget.controller.text.isEmpty) {
      return null;
    }

    if (_hasError) {
      return Icon(
        Icons.error_outline,
        color: Theme.of(context).colorScheme.error,
      );
    }

    if (_isValid) {
      return Icon(
        Icons.check_circle_outline,
        color: Theme.of(context).colorScheme.primary,
      );
    }

    return Icon(
      Icons.info_outline,
      color: Theme.of(context).colorScheme.outline,
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = widget.controller.text;
    double strength = 0.0;
    String strengthText = 'Weak';
    Color strengthColor = Theme.of(context).colorScheme.error;

    if (password.length >= 8) {
      strength += 0.25;
    }
    if (password.length >= 12) {
      strength += 0.25;
    }
    if (password.contains(RegExp(r'[A-Z]'))) {
      strength += 0.25;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      strength += 0.25;
    }

    if (strength >= 0.75) {
      strengthText = 'Strong';
      strengthColor = Theme.of(context).colorScheme.primary;
    } else if (strength >= 0.5) {
      strengthText = 'Medium';
      strengthColor = Theme.of(context).colorScheme.tertiary;
    } else if (strength >= 0.25) {
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    }

    return Row(
      children: [
        Text(
          'Strength: $strengthText',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: strengthColor,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          ),
        ),
      ],
    );
  }
}
