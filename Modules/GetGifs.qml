import QtQuick
import Qt.labs.folderlistmodel

Item {
	id: root

	property alias count: folderModel.count
	required property string gifFolder
	property alias gifsModel: folderModel

	FolderListModel {
		id: folderModel

		folder: "file://" + root.gifFolder
		nameFilters: ["*.gif"]
		showDirs: false
		showHidden: false
		sortField: FolderListModel.Name
	}
}
