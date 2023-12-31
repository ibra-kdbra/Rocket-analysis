import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
	id: boundaryPanel
	width: 1280
	height: 720
	visible: true
	title: qsTr("Boundary Panel")

	onClosing: {
		for (var i = 0; i < grid.children.length; i++) {
			grid.children[i].destroy();
		}
	}

	Component.onCompleted: {
		var boundaries = actions.getBoundaries();
		for (var i = 0; i < boundaries.length; i+=4) {
			var button = buttonDelegate.createObject(grid);
			button.text = boundaries[i];
			button.objectName = "boundaryButton" + boundaries[i];
			var comboBox = comboBoxDelegate.createObject(grid);
			comboBox.currentIndex = boundaries[i+1];
			comboBox.objectName = "boundaryComboBox" + boundaries[i];
			var value = valueDelegate.createObject(grid);
			value.text = boundaries[i+2];
			value.objectName = "boundaryValue" + boundaries[i];
			var description = descriptionDelegate.createObject(grid);
			description.text = boundaries[i+3];
			description.objectName = "boundaryDescription" + boundaries[i];
		}
	}

	contentData: RowLayout {
		anchors.fill: parent
		anchors.margins: 10
		spacing: 10

		GroupBox {
			title: qsTr("Boundary conditions")
			Layout.fillHeight: true
			Layout.fillWidth: true
			ScrollView {
				anchors.fill: parent
				clip: true
				GridLayout {
					id: grid
					columns: 4
					width: parent.parent.width

					Component {
						id: buttonDelegate
						Button {}
					}

					Component {
						id: comboBoxDelegate
						ComboBox {
							model: ["Inlet", "Outlet", "Symmetry"]
							Layout.preferredWidth: 150
						}
					}

					Component {
						id: valueDelegate
						TextField {
							placeholderText: qsTr("value")
							validator: DoubleValidator {}
							Layout.preferredWidth: 200
							Component.onCompleted: cursorPosition = 0
						}
					}

					Component {
						id: descriptionDelegate
						TextField {
							placeholderText: qsTr("description")
							Layout.fillWidth: true
						}
					}
				}
			}
		}
	}

	footer: Row {
		width: parent.width
		layoutDirection: Qt.RightToLeft
		rightPadding: 10
		spacing: 10

		Button {
			text: qsTr("Cancel")
			onClicked: boundaryPanel.close();
		}
		Button {
			text: qsTr("Save")
			onClicked: {
				actions.updateBoundaries(saveToFile.checked, savePretty.checked);
				boundaryPanel.close();
			}
		}
		CheckBox {
			id: saveToFile
			text: qsTr("Save to file")
		}
		CheckBox {
			id: savePretty
			text: qsTr("Save pretty")
			visible: saveToFile.checked
		}
	}
}
