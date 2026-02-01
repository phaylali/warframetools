import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import '../core/services/pocketbase_service.dart';
import '../core/constants/app_constants.dart';
import '../widgets/common/app_toolbar.dart';
import '../widgets/common/avatar_chooser_dialog.dart';
import '../widgets/relic/sync_conflict_dialog.dart';
import '../widgets/common/fading_gold_divider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _isLoading = false;
  bool _isCheckingConnection = true;
  String? _errorMessage;
  bool _serverConnected = false;

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
    _refreshAuthState();
  }

  Future<void> _refreshAuthState() async {
    try {
      if (PocketBaseService.isAuthenticated) {
        await PocketBaseService.authRefresh();
        if (mounted) setState(() {});
      }
    } catch (e) {
      // Ignore errors here, just best effort refresh
    }
  }

  Future<void> _checkServerConnection() async {
    setState(() => _isCheckingConnection = true);
    try {
      final connected = await PocketBaseService.checkConnection();
      setState(() => _serverConnected = connected);
    } catch (e) {
      setState(() => _serverConnected = false);
    } finally {
      setState(() => _isCheckingConnection = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    try {
      PocketBaseService.signOut();
      if (mounted) {
        context.go(AppConstants.homeRoute);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sign Out'),
            const SizedBox(height: 8),
            const FadingGoldDivider(horizontalMargin: 0),
          ],
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = PocketBaseService.isAuthenticated;
    final pb = PocketBaseService.instance;

    return Scaffold(
      appBar: const AppToolbar(
        title: 'Account',
        showBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: _checkServerConnection,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConnectionStatus(context),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
              ],
              if (!isAuthenticated)
                _buildNotSignedInState(context)
              else
                _buildSignedInState(context, pb),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    final isAuthenticated = PocketBaseService.isAuthenticated;

    return Card(
      elevation: 0,
      color: _serverConnected
          ? Theme.of(context).colorScheme.primary.withAlpha(20)
          : Theme.of(context).colorScheme.error.withAlpha(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _serverConnected
              ? Theme.of(context).colorScheme.primary.withAlpha(100)
              : Theme.of(context).colorScheme.error.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _serverConnected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: _isCheckingConnection
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    )
                  : Icon(
                      _serverConnected ? Icons.cloud_sync : Icons.cloud_off,
                      color: _serverConnected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Server Connection',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isCheckingConnection
                        ? 'Checking connection...'
                        : _serverConnected
                            ? (isAuthenticated
                                ? 'Connected • Sync Active'
                                : 'Connected')
                            : 'Disconnected • Offline Mode',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
            if (_serverConnected && !isAuthenticated)
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotSignedInState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Not Signed In',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to sync your relic counters across devices',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: AppConstants.maxButtonWidth),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _showEmailSignInDialog,
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSignUpPrompt(context),
      ],
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Don\'t have an account? Create one to start tracking your relics with cloud sync.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppConstants.maxButtonWidth),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showSignUpDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create Account'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Delete Account'),
              const SizedBox(height: 8),
              const FadingGoldDivider(horizontalMargin: 0),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.'),
              const SizedBox(height: 16),
              const Text(
                'Please enter your password to confirm:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscurePassword = !obscurePassword),
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: obscurePassword,
                autocorrect: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => _deleteAccount(passwordController.text),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(String password) async {
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password');
      // Clear the error message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _errorMessage = null);
        }
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await PocketBaseService.deleteAccount(password);
      if (mounted) {
        Navigator.pop(context); // Close the delete dialog
        // Navigate to home after account deletion
        context.go(AppConstants.homeRoute);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      // Clear the error message after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() => _errorMessage = null);
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;
    String? dialogError;
    bool isDialogLoading = false;

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Change Password'),
              const SizedBox(height: 8),
              const FadingGoldDivider(horizontalMargin: 0),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    errorText: dialogError,
                    errorMaxLines: 3,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setDialogState(() =>
                          obscureCurrentPassword = !obscureCurrentPassword),
                      icon: Icon(obscureCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: obscureCurrentPassword,
                  enabled: !isDialogLoading,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setDialogState(
                          () => obscureNewPassword = !obscureNewPassword),
                      icon: Icon(obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: obscureNewPassword,
                  enabled: !isDialogLoading,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setDialogState(() =>
                          obscureConfirmPassword = !obscureConfirmPassword),
                      icon: Icon(obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: obscureConfirmPassword,
                  enabled: !isDialogLoading,
                ),
              ],
            ),
          ),
          actions: [
            if (isDialogLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final currentPassword = currentPasswordController.text;
                  final newPassword = newPasswordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (currentPassword.isEmpty ||
                      newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    setDialogState(
                        () => dialogError = 'Please fill in all fields');
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    setDialogState(
                        () => dialogError = 'New passwords do not match');
                    return;
                  }

                  if (newPassword.length < 8) {
                    setDialogState(() =>
                        dialogError = 'Password must be at least 8 characters');
                    return;
                  }

                  setDialogState(() {
                    isDialogLoading = true;
                    dialogError = null;
                  });

                  try {
                    await PocketBaseService.changePassword(
                        currentPassword, newPassword);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() {
                        isDialogLoading = false;
                        final error = e.toString();
                        // Attempt to parse common auth errors
                        if (error.contains('Failed to authenticate') ||
                            error.contains('400')) {
                          dialogError =
                              'Incorrect current password or invalid request.';
                        } else {
                          dialogError =
                              'Failed to change password. Please try again.';
                        }
                      });
                    }
                  }
                },
                child: const Text('Change Password'),
              ),
            ],
          ],
        ),
      ),
    ).then((success) async {
      if (success == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed. Logging out...'),
            ),
          );
          // Wait briefly then sign out
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) _signOut();
        }
      }
    });
  }

  void _showChangeEmailDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;
    String? dialogError;
    bool isDialogLoading = false;

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Change Email'),
              const SizedBox(height: 8),
              const FadingGoldDivider(horizontalMargin: 0),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your new email address:'),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  errorText: dialogError,
                  errorMaxLines: 3,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !isDialogLoading,
              ),
              const SizedBox(height: 12),
              const Text('Enter your password to confirm:'),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () => setDialogState(
                        () => obscurePassword = !obscurePassword),
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: obscurePassword,
                enabled: !isDialogLoading,
              ),
            ],
          ),
          actions: [
            if (isDialogLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final newEmail = emailController.text.trim();
                  final password = passwordController.text;

                  if (newEmail.isEmpty || password.isEmpty) {
                    setDialogState(
                        () => dialogError = 'Please fill in all fields');
                    return;
                  }

                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(newEmail)) {
                    setDialogState(() =>
                        dialogError = 'Please enter a valid email address');
                    return;
                  }

                  setDialogState(() {
                    isDialogLoading = true;
                    dialogError = null;
                  });

                  try {
                    // Verify password first
                    final currentEmail = PocketBaseService.currentUserEmail;
                    if (currentEmail != null) {
                      await PocketBaseService.authenticateWithPassword(
                          currentEmail, password);
                    }

                    // Request email change (this sends the email)
                    await PocketBaseService.requestEmailChange(newEmail);

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() {
                        isDialogLoading = false;
                        final error = e.toString();
                        if (error.contains('data.email') &&
                            error.contains('taken')) {
                          dialogError = 'This email is already in use.';
                        } else if (error.contains('data.email') &&
                            error.contains('invalid')) {
                          dialogError = 'Please enter a valid email address.';
                        } else {
                          // Fallback to a generic message but log the actual error if possible or show simplified
                          dialogError =
                              'Failed to update email. Please try again.';
                        }
                      });
                    }
                  }
                },
                child: const Text('Change Email'),
              ),
            ],
          ],
        ),
      ),
    ).then((success) async {
      if (success == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Email change requested. Logging out... Please check your new email to confirm.'),
            ),
          );
          // Wait briefly then sign out
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) _signOut();
        }
      }
    });
  }

  void _showChangeUsernameDialog() {
    final usernameController = TextEditingController(
      text: PocketBaseService.currentUserName ?? '',
    );
    String? dialogError;
    bool isDialogLoading = false;

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Change Username'),
              const SizedBox(height: 8),
              const FadingGoldDivider(horizontalMargin: 0),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your new username:'),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'New Username',
                  errorText: dialogError,
                  errorMaxLines: 3,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                enabled: !isDialogLoading,
              ),
            ],
          ),
          actions: [
            if (isDialogLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final newUsername =
                      usernameController.text.trim().toLowerCase();
                  if (newUsername.isEmpty) {
                    setDialogState(
                        () => dialogError = 'Please enter a username');
                    return;
                  }

                  setDialogState(() {
                    isDialogLoading = true;
                    dialogError = null;
                  });

                  try {
                    await PocketBaseService.updateUserProfile(
                        username: newUsername);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() {
                        isDialogLoading = false;
                        final error = e.toString();
                        if (error.contains('data.username') &&
                            error.contains('taken')) {
                          dialogError = 'This username is already taken.';
                        } else {
                          dialogError =
                              'Failed to update username. Please try again.';
                        }
                      });
                    }
                  }
                },
                child: const Text('Change Username'),
              ),
            ],
          ],
        ),
      ),
    ).then((success) async {
      if (success == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Username updated. Logging out to apply changes...'),
              backgroundColor: Colors.blue,
            ),
          );
          // Wait briefly then sign out
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) _signOut();
        }
      }
    });
  }

  void _showChangeAvatarDialog() {
    // Get current user's avatar URL
    final authRecord = PocketBaseService.authRecord;
    final currentAvatarUrl = authRecord?['avatarUrl'] as String?;

    showDialog(
      context: context,
      builder: (context) => AvatarChooserDialog(
        currentAvatarUrl: currentAvatarUrl,
      ),
    ).then((selectedAvatarUrl) {
      if (selectedAvatarUrl != null && selectedAvatarUrl != currentAvatarUrl) {
        // Apply the selected avatar
        _applyAvatar(selectedAvatarUrl);
      }
    });
  }

  Future<void> _applyAvatar(String avatarUrl) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await PocketBaseService.updateUserProfile(avatarUrl: avatarUrl);
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      // Clear the error message after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() => _errorMessage = null);
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSignedInState(BuildContext context, PocketBase? pb) {
    final authStore = pb?.authStore;
    final userModel = authStore?.record;
    final email = userModel?.getStringValue('email') ?? 'Unknown';
    final username = userModel?.getStringValue('username') ?? 'Unknown';
    final createdAt = userModel?.getStringValue('created') ?? 'Unknown';
    final isVerified = userModel?.getBoolValue('verified') ?? false;
    final avatarUrl = userModel?.getStringValue('avatarUrl');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildUserInfoCard(
            context, email, username, createdAt, isVerified, avatarUrl),
        const SizedBox(height: 12),
        if (!isVerified)
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppConstants.maxButtonWidth),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _isLoading ? null : _requestVerification,
                  icon: const Icon(Icons.mark_email_read),
                  label: const Text('Verify Email Address'),
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Account Management'),
        const SizedBox(height: 8),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: _isLoading ? null : _showChangePasswordDialog,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Change Email'),
                onTap: _isLoading ? null : _showChangeEmailDialog,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Change Username'),
                onTap: _isLoading ? null : _showChangeUsernameDialog,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Change Avatar'),
                onTap: _isLoading ? null : _showChangeAvatarDialog,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppConstants.maxButtonWidth),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _isLoading ? null : _showSignOutDialog,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      minimumSize: const Size.fromHeight(56),
                    ),
                    onPressed: _isLoading ? null : _showDeleteAccountDialog,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(
    BuildContext context,
    String email,
    String username,
    String createdAt,
    bool isVerified,
    String? avatarUrl,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isVerified ? Icons.verified : Icons.pending,
                            size: 16,
                            color: isVerified
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isVerified ? 'Verified' : 'Unverified',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: isVerified
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Email', email),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Created', _formatDate(createdAt)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == 'Unknown') return dateStr;
    try {
      final date = DateTime.parse(dateStr);
      final year = date.year;
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  void _showEmailSignInDialog() {
    setState(() => _errorMessage = null);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In with Email',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscurePassword = !obscurePassword),
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: obscurePassword,
                autocorrect: false,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showForgotPasswordDialog();
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppConstants.maxButtonWidth),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: AppConstants.maxButtonWidth),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () => _signInWithEmail(
                                emailController.text,
                                passwordController.text,
                                setState,
                              ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmail(
    String email,
    String password,
    void Function(void Function()) setDialogState,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      setDialogState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    setDialogState(() {});

    try {
      await PocketBaseService.authenticateWithPassword(email, password);
      if (mounted) {
        Navigator.pop(context);
        _showSyncConflictDialog();
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setDialogState(() {
          final errorStr = e.toString().toLowerCase();
          if (errorStr.contains('400') ||
              errorStr.contains('failed to authenticate')) {
            _errorMessage = 'Email or Password are incorrect';
          } else {
            _errorMessage = e.toString();
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        setDialogState(() {});
      }
    }
  }

  void _showSignUpDialog() {
    setState(() => _errorMessage = null);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final usernameController = TextEditingController(
      text: PocketBaseService.generateUsername(),
    );
    bool obscurePassword = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null) ...[
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: AppConstants.maxButtonWidth),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setDialogState(
                          () => obscurePassword = !obscurePassword),
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: obscurePassword,
                  autocorrect: false,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: obscurePassword,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppConstants.maxButtonWidth),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading
                            ? null
                            : () => _signUp(
                                  emailController.text,
                                  passwordController.text,
                                  confirmPasswordController.text,
                                  usernameController.text,
                                  setDialogState,
                                ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Create Account'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(
    String email,
    String password,
    String confirmPassword,
    String username,
    void Function(void Function()) setDialogState,
  ) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      setDialogState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      setDialogState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    if (password.length < 8) {
      setDialogState(
          () => _errorMessage = 'Password must be at least 8 characters');
      return;
    }

    setDialogState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await PocketBaseService.signUp(
        email: email,
        password: password,
        username: username.toLowerCase(),
      );
      if (mounted) {
        Navigator.pop(context);
        _showSyncConflictDialog();
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setDialogState(() {
          final errorStr = e.toString().toLowerCase();
          if (errorStr.contains('400')) {
            _errorMessage =
                'Invalid information provided. The email or username might already be in use.';
          } else {
            _errorMessage = e.toString();
          }
        });
      }
    } finally {
      if (mounted) {
        setDialogState(() => _isLoading = false);
      }
    }
  }

  Future<void> _requestVerification() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = PocketBaseService.currentUserEmail;
      if (email != null) {
        await PocketBaseService.requestVerification(email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification email sent'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    String? dialogError;
    bool isDialogLoading = false;

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Enter your email address to receive a password reset link.'),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  errorText: dialogError,
                  errorMaxLines: 3,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !isDialogLoading,
              ),
            ],
          ),
          actions: [
            if (isDialogLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    setDialogState(
                        () => dialogError = 'Please enter your email');
                    return;
                  }

                  setDialogState(() {
                    isDialogLoading = true;
                    dialogError = null;
                  });

                  try {
                    await PocketBaseService.requestPasswordReset(email);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() {
                        isDialogLoading = false;
                        dialogError = 'Request failed: ${e.toString()}';
                      });
                    }
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ],
        ),
      ),
    ).then((success) {
      if (success == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'If an account exists for ${emailController.text}, a reset email has been sent.'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    });
  }

  void _showSyncConflictDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SyncConflictDialog(),
    );
  }
}
