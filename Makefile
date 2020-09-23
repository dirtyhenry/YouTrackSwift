install:
	brew bundle
	swift package update

open:
	open Package.swift

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
	rm -rf .build .swiftpm

doc:
	swift doc generate Sources --module-name YouTrackSwift 
