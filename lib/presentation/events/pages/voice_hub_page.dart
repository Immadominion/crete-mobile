import 'package:flutter/material.dart';

import 'creative_voice_hub_page.dart';

/// Legacy Voice Hub Page - Redirects to new Creative Voice Hub
/// This file is kept for backward compatibility but redirects to the new creative interface
class VoiceHubPage extends StatelessWidget {
  const VoiceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to the new creative voice hub page
    return const CreativeVoiceHubPage();
  }
}
