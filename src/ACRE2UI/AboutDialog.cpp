#include "AboutDialog.hpp"
#include "ui_AboutDialog.h"

#include <cstdlib>
#include "Macros.h"

AboutDialog::AboutDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::AboutDialog) {
	ui->setupUi(this);

	ui->version->setText(QString(ACRE_VERSION));
}
AboutDialog::~AboutDialog() {
	delete ui;
}
