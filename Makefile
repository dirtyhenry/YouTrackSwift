install:
	swift package update
	swift package generate-xcodeproj

lint:
	swift run swiftlint

lintfix:
	swift run swiftlint autocorrect

clean:
	rm -rf .build
