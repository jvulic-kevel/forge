let
  # The DZ60RGB. All custom remaps below are scoped to this device only.
  dz60Identifier = {
    vendor_id = 17498;
    product_id = 4641;
  };
  onDz60 = {
    type = "device_if";
    identifiers = [ dz60Identifier ];
  };

  # Terminal emulators keep their native Ctrl behavior (SIGINT, etc.) instead
  # of getting the Linux-style Cmd/Option remap below.
  terminalBundleIds = [
    "^com\\.mitchellh\\.ghostty$"
    "^com\\.apple\\.Terminal$"
    "^com\\.googlecode\\.iterm2$"
    "^org\\.alacritty$"
    "^com\\.microsoft\\.rdc.*"
    "^com\\.vmware\\.fusion$"
    "^com\\.parallels\\.desktop$"
  ];
  notInTerminal = {
    type = "frontmost_application_unless";
    bundle_identifiers = terminalBundleIds;
  };

  # Ctrl+<key> -> Cmd+<key>, e.g. Ctrl+C to Cmd+C (Copy).
  ctrlToCmd = [
    {
      key = "c";
      label = "Copy";
    }
    {
      key = "v";
      label = "Paste";
    }
    {
      key = "x";
      label = "Cut";
    }
    {
      key = "z";
      label = "Undo";
    }
    {
      key = "a";
      label = "Select All";
    }
    {
      key = "s";
      label = "Save";
    }
    {
      key = "f";
      label = "Find";
    }
    {
      key = "w";
      label = "Close Tab";
    }
    {
      key = "t";
      label = "New Tab";
    }
    {
      key = "r";
      label = "Refresh";
    }
  ];

  # Ctrl+Shift+<key> -> Cmd+Shift+<key>. Listed separately (and matched before
  # ctrlToCmd below) so Shift isn't dropped, e.g. Ctrl+Shift+R for hard refresh
  # instead of falling through to the plain Ctrl+R -> Cmd+R refresh mapping.
  ctrlShiftToCmdShift = [
    {
      key = "r";
      label = "Hard Refresh";
    }
    {
      key = "c";
      label = "Open Dev Console";
    }
  ];

  # Ctrl+<key> -> Option+<key>, e.g. Ctrl+Backspace to Option+Backspace (word delete).
  ctrlToOption = [
    {
      key = "delete_or_backspace";
      label = "Delete Word";
    }
    {
      key = "left_arrow";
      label = "Move Word Left";
    }
    {
      key = "right_arrow";
      label = "Move Word Right";
    }
  ];

  ctrlManipulator = toModifier: { key, label }: {
    description = "Ctrl+${key} to ${if toModifier == "command" then "Cmd" else "Option"}+${key} (${label})";
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        mandatory = [ "control" ];
        optional = [ "any" ];
      };
    };
    to = [
      {
        key_code = key;
        modifiers = [ "left_${toModifier}" ];
      }
    ];
    conditions = [
      onDz60
      notInTerminal
    ];
  };

  ctrlShiftManipulator = { key, label }: {
    description = "Ctrl+Shift+${key} to Cmd+Shift+${key} (${label})";
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        mandatory = [
          "control"
          "shift"
        ];
        optional = [ "any" ];
      };
    };
    to = [
      {
        key_code = key;
        modifiers = [
          "left_command"
          "left_shift"
        ];
      }
    ];
    conditions = [
      onDz60
      notInTerminal
    ];
  };

in
{
  title = "DZ60RGB keyboard";
  rules = [
    {
      description = "Customize the DZ60RGB keyboard such that the experience using it on Mac is more Linux-like.";
      # Ctrl+Shift+<key> manipulators must come first: Karabiner matches
      # manipulators in order, and the plain Ctrl+<key> rules below use
      # `optional: any` so they'd otherwise swallow the Shift-held combos too.
      manipulators =
        (map ctrlShiftManipulator ctrlShiftToCmdShift)
        ++ (map (ctrlManipulator "command") ctrlToCmd)
        ++ (map (ctrlManipulator "option") ctrlToOption);
    }
  ];
}
