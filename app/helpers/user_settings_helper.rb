module UserSettingsHelper
  def reverse_mode_label(mode)
    mode.to_s == UserSetting::REVERSE_MODE.to_s ? '逆路' : '順路'
  end

  def reverse_mode_list
    [UserSetting::NORMAL_MODE, UserSetting::REVERSE_MODE].map {|x| [reverse_mode_label(x), x]}
  end
end
