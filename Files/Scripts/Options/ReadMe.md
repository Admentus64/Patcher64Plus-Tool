Adding new options is easy. Two things have to be done when adding a new checkbox for example. Adding the actual interface element, and the code that applies the change.

Adding a new interface element can be done in one of two ways: Assign it to a tab or to the window itself without any tabs. Interface elements generations starts with the `CreateOptions` function. Those can be generated in here after the `CreateOptionsDialog` function or the `CreateOptionsDialog` can be used to generate tabs.

No tabs example:
```
CreateOptionsDialog -Columns 1 -Height 190
```

Tabs example:
```
CreateOptionsDialog -Columns 6 -Height 600 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Scenes", "Colors", "Equipment", "Capacity", "Animations")
```

The tabs `Redux` and `Language` do not need to be provided and are handled automaticially. The `-NoLanguages` parameter can be passed to force disabling language interface options generation. The tab `Main` is generated automaticially when no tabs are provided.

When working with tabs, a tab window can be executed by calling it's function: `CreateTabMain`, as example when the tab you want to call is named `Main`. Replace `Main` with the name of the tab you want to call.

Then you can start adding interface elements such as a checkbox, with for example:
```
CreateReduxCheckBox -Name "RemoveNaviPrompts" -Text "Remove Navi Prompts" -Info "Navi will no longer interrupt you with tutorial text boxes in dungeons"
```

The code change goes into one of these functions, which depends on what kind of code change it is.

```
PrePatchOptions      = Apply patch files before Redux kicks in
PatchOptions         = Apply patch files
ByteOptions          = Apply smaller byte changes
RevertReduxOptions   = For reverting Redux content if needed
ByteReduxOptions     = Apply smaller byte changes when Redux is enabled
CheckLanguageOptions = Perform checks as to when to allow to kick in the Text Editor options
WholeLanguageOptions = For patching entire dialogue scripts
ByteLanguageOptions  = Apply Text Editor changes when CheckLanguageOptions is passed
```

Following the checkbox example from above you would have to place the code to applying the ROM change into `ByteOptions`:
```
if (IsChecked $Redux.Gameplay.RemoveNaviPrompts) { ChangeBytes -Offset "DF8B84" -Values "00000000" }
```

Make sure to close and reopen the Patcher64+ Tool after making code adjustments and to try patching your newly added option. Please make sure the Console Log is enabled for an easier time to understand if an error occcured when you test out your option. It can provide a suggestion on what you did wrong. Patching is likely to fail and spit out an error if it's not placed in the correct function. Code placed in `ByteLanguageOptions` relies on passing a check from `CheckLanguageOptions`, which is used to allow running `ByteLanguageOptions` is a relevant options such as a checkbox is enabled.

Please contact Admentus over at the Mod64+ discord server if you feel any information is missing, for either this ReadMe or the Console Log.

For suggestions, look in the Ocarina of Time.psm1 and Majora's Mask.psm1 script files which are the most expansive.