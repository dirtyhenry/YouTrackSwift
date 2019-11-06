install:
	swift package update
	swift package generate-xcodeproj

open:
	open YouTrackSwift.xcodeproj

build:
	swift build

test:
	swift test

lint:
	swift run swiftlint

lintfix:
	swift run swiftlint autocorrect
	swift run swiftformat .

clean:
	rm -rf .build
