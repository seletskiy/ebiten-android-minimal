ANDROID_PACKAGE=io.reconquest.app
ANDROID_SDK_VERSION=28.0.3
ANDROID_SDK_PATH=/opt/android-sdk
ANDROID_JAR_VERSION=29

KEYS_DN=DC=io,CN=reconquest
KEYS_PASS=123456
KEYS_VALIDITY=365
KEYS_ALGORITHM=RSA
KEYS_SIZE=2048

BUILD_DIR=build

_BUILD_TOOLS=$(ANDROID_SDK_PATH)/build-tools/$(ANDROID_SDK_VERSION)
_ANDROID_JAR_PATH=$(ANDROID_SDK_PATH)/platforms/android-$(ANDROID_JAR_VERSION)/android.jar
_JAVA_SRC=$(shell find src -name '*.java')

clean:
	@rm -rf $(BUILD_DIR)

keys.store:
	keytool -genkeypair \
		-validity $(KEYS_VALIDITY) \
		-keystore $@ \
		-keyalg $(KEYS_ALGORITHM) \
		-keysize $(KEYS_SIZE) \
		-storepass $(KEYS_PASS) \
		-keypass $(KEYS_PASS) \
		-dname $(KEYS_DN) \
		-deststoretype pkcs12

$(BUILD_DIR)/app.aar:
	@mkdir -p $(BUILD_DIR)

	GO111MODULE=off ebitenmobile bind \
		-target android \
		-javapkg $(ANDROID_PACKAGE) \
		-o $(BUILD_DIR)/app.aar \
		github.com/seletskiy/ebiten-android-minimal

	@unzip -o -qq $(BUILD_DIR)/app.aar -d $(BUILD_DIR)/aar
	@ln -sf aar/jni $(BUILD_DIR)/lib

resources:
	$(_BUILD_TOOLS)/aapt package \
		-f \
		-m \
		-J src \
		-M AndroidManifest.xml \
		-S res \
		-I $(_ANDROID_JAR_PATH)

compile: $(BUILD_DIR)/app.aar
	@mkdir -p $(BUILD_DIR)/obj

	javac \
		-d $(BUILD_DIR)/obj \
		-classpath src:$(BUILD_DIR)/aar/classes.jar \
		-bootclasspath $(_ANDROID_JAR_PATH) \
		$(_JAVA_SRC)

dex:
	$(_BUILD_TOOLS)/dx \
		--dex \
		--output $(BUILD_DIR)/classes.dex \
		$(BUILD_DIR)/obj \
		$(BUILD_DIR)/aar/classes.jar

$(BUILD_DIR)/app.apk.unaligned: $(BUILD_DIR)/app.aar resources compile dex
	$(_BUILD_TOOLS)/aapt package \
		-f \
		-m \
		-F $(BUILD_DIR)/app.apk.unaligned \
		-M AndroidManifest.xml \
		-S res \
		-I $(_ANDROID_JAR_PATH)

	cd $(BUILD_DIR) && $(_BUILD_TOOLS)/aapt add \
		app.apk.unaligned \
		classes.dex \
		lib/*/*

$(BUILD_DIR)/app.apk: keys.store $(BUILD_DIR)/app.apk.unaligned
	$(_BUILD_TOOLS)/zipalign \
		-f 4 \
		$(BUILD_DIR)/app.apk.unaligned \
		$(BUILD_DIR)/app.apk

	$(_BUILD_TOOLS)/apksigner sign \
		--ks keys.store \
		--ks-pass pass:$(KEYS_PASS) \
		$(BUILD_DIR)/app.apk

install: $(BUILD_DIR)/app.apk
	adb install $(BUILD_DIR)/app.apk

run: install
	adb shell am start -n $(ANDROID_PACKAGE)/.MainActivity
