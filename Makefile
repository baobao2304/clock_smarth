
.PHONY: doctor
d:
	fvm flutter doctor
.PHONY: setup
setup:
	dart pub global activate fvm
	fvm use 3.24.4
	fvm install
	fvm flutter precache
	$(MAKE) clean



.PHONY: dependencies
dependencies:
	#install
	fvm flutter pub get

.PHONY: analyze
analyze:
	fvm flutter analyze

.PHONY: format
format:
	fvm dart format lib/

.PHONY: format-analyze
format-analyze:
	dart format . -l 120
	#fvm flutter analyze

.PHONY: build-runner

load-language:
	fvm  flutter gen-l10n --arb-dir=lib/core/localization/l10n/ --template-arb-file=intl_en.arb --output-localization-file=l10n.dart --output-class=S --output-dir=lib/core/localization/generated/ --no-synthetic-package


build-runner:
	fvm dart pub add dev:build_runner
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

w:
	fvm flutter packages pub run build_runner watch --delete-conflicting-outputs


.PHONY: run-build-firebase-distribution-dev
run-build-dev:
	fvm flutter build ios --flavor dev --dart-define\=FLAVOR\=dev
	cd ios && bundle exec fastlane dev

.PHONY: run-build-firebase-distribution-stg
run-build-stg:
	fvm flutter build ios --flavor stg --dart-define\=FLAVOR\=stg
	cd ios && bundle exec fastlane stg

run-build-prod:
	fvm flutter build ios --flavor prod --dart-define\=FLAVOR\=prod
	cd ios && bundle exec fastlane prod


## build release apk or ipa

.PHONY: build-android-stag
build-android-staging:
	fvm flutter build apk --flavor staging --dart-define=FLAVOR=staging --target lib/main_staging.dart

.PHONY: build-android-dev
build-android-dev:
	fvm flutter build apk --flavor development --dart-define=FLAVOR=development --target lib/main_development.dart

.PHONY: build-android-prd
build-aab-prd:
	fvm flutter build appbundle --flavor prod --dart-define\=FLAVOR\=prod
build-apk-prd:
	fvm flutter build apk --flavor prod --dart-define\=FLAVOR\=prod

.PHONY: unit-test
unit-test:
	fvm flutter test --coverage --coverage-path=./coverage/lcov.info

clean-ios:
	rm ios/Podfile.lock | true
	rm -rf ios/Pods/ | true
	rm -rf ios/Runner.xcworkspace/ | true
	rm ios/Flutter/Flutter.podspec | true
	rm -rf ~/Library/Developer/Xcode/DerivedData/
	rm pubspec.lock | true
	fvm flutter clean
	fvm flutter pub get
	cd ios&&pod install

clean-android:
	fvm flutter clean
	rm -rf ~/.gradle/caches/
	rm -rf ~/.gradle/daemon/
	rm -rf ~/.gradle/native/
	rm -rf android/.gradle
	rm -rf android/build
	fvm flutter pub get
pod:
	rm ios/Podfile.lock | true
	rm -rf ios/Pods | true
	cd ios &&pod install

