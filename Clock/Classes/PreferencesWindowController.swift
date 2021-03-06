import AppKit
import ScreenSaver

final class PreferencesWindowController: NSWindowController {
	
	// MARK: - Properties

	@IBOutlet weak var modelPopUpButton: NSPopUpButton!
	@IBOutlet weak var stylePopUpButton: NSPopUpButton!

	override var windowNibName: NSNib.Name? {
		return NSNib.Name(rawValue: "Preferences")
	}

	private let preferences = Preferences()

	// MARK: - NSObject

	override func awakeFromNib() {
		super.awakeFromNib()

		NotificationCenter.default.addObserver(self, selector: #selector(modelDidChange), name: .ModelDidChange, object: nil)

		stylePopUpButton.removeAllItems()

		let models = preferences.models
		modelPopUpButton.addItems(withTitles: models.map { $0.modelName })

		let styles = preferences.model.styles
		stylePopUpButton.addItems(withTitles: styles.map { $0.description })

		let index = styles.map { $0.rawValue }.index(of: preferences.styleName) ?? styles.startIndex
		stylePopUpButton.selectItem(at: index)
	}
	
	
	// MARK: - Actions

	@IBAction func selectStyle(_ sender: Any?) {
		preferences.styleName = preferences.model.styles[stylePopUpButton.indexOfSelectedItem].rawValue
	}

	@IBAction func close(_ sender: Any?) {
		window?.close()
	}

	// MARK: - Private

	@objc private func modelDidChange(_ notification: NSNotification?) {
		stylePopUpButton.removeAllItems()
		stylePopUpButton.addItems(withTitles: preferences.model.styles.map { $0.description })
		
		stylePopUpButton.selectItem(at: 0)
		selectStyle(stylePopUpButton)
	}
}
