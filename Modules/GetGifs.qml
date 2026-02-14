import QtQuick
import Qt.labs.folderlistmodel

Item {
	id: root
	required property string gifFolder

	property alias gifsModel: folderModel
	property alias count: folderModel.count

	FolderListModel {
		id: folderModel
		folder: "file://" + root.gifFolder
		nameFilters: [ "*.gif" ]
		showDirs: false
		showHidden: false
		sortField: FolderListModel.Name
	}
}
