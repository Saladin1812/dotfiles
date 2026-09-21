let
  band = type: frequency: {
    inherit type frequency;
    mode = "RLC (BT)";
    slope = "x1";
    gain = 0.0;
    q = 0.707;
    width = 4.0;
    solo = false;
    mute = false;
  };
  channels = {
    band0 = band "Hi-pass" 80.0;
    # Neutral starting points: tune frequency, gain and Q for your voice.
    band1 = band "Bell" 250.0;
    band2 = band "Bell" 2500.0;
    band3 = band "Bell" 6000.0;
  };
in
{
  enable = true;

  # Load the starter preset manually once; retain subsequent GUI adjustments.
  extraPresets."Mic EQ Starter".input = {
    blocklist = [ ];
    plugins_order = [ "equalizer#0" ];
    "equalizer#0" = {
      bypass = false;
      input-gain = 0.0;
      output-gain = 0.0;
      mode = "IIR";
      num-bands = 4;
      split-channels = false;
      balance = 0.0;
      pitch-left = 0.0;
      pitch-right = 0.0;
      left = channels;
      right = channels;
    };
  };

  settings = {
    # OBS explicitly selects the virtual microphone; other apps keep their routing.
    EffectsPipelines = {
      processAllInputs = false;
      processAllOutputs = false;
    };
    StreamInputs = {
      useDefaultInputDevice = false;
      inputDevice = "alsa_input.usb-HP__Inc_HyperX_SoloCast-00.analog-stereo";
      listenToMic = false;
    };
  };
}
