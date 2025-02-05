import 'package:flutter/material.dart';
import 'package:drkwon/pages/state_data_down_up/state_data_down_up_color_mixer.dart';
import 'package:drkwon/widgets/app_drawer.dart';

class ColorMixerScreen extends StatelessWidget 
{
  const ColorMixerScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Color Mixer'),
      ),
      drawer: AppDrawer(),
      body: const Center
      (
        child: ColorMixer(),
      ),
    );
  }
}