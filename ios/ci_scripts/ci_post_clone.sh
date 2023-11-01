# #!/bin/sh

# # The default execution directory of this script is the ci_scripts directory.
cd $CI_WORKSPACE # change working directory to the root of your cloned repo.

# Obtenez le numéro de version actuel à partir du fichier Info.plist
 # versionNumber=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Info.plist)

# Divisez la version en composants majeurs et mineurs
 # IFS='.' read -r -a versionComponents <<< "$versionNumber"

# Incrémentez le composant mineur (ou majeur, selon vos besoins)
 # newMinorVersion=$((versionComponents[1] + 1))

# Mettez à jour la version dans le fichier Info.plist
 # newVersion="${versionComponents[0]}.$newMinorVersion"
   # /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $newVersion" Info.plist


# # Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b flutter-3.13-candidate.2 $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# # Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# # Install Flutter dependencies.
flutter pub get

# # Install CocoaPods using Homebrew ####. 
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# # Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

# Ligne de code que vous souhaitez commenter
line_to_comment="target 'RunnerTests' do inherit! :search_paths end"

# Commentez la ligne en utilisant un caractère #
sed -i.bak "s|$line_to_comment|# $line_to_comment|" Podfile

exit 0