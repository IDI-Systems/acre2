#include "WelcomeDialog.hpp"
#include "ui_WelcomeDialog.h"
#include <QUrl>

#include <cstdlib>

WelcomeDialog::WelcomeDialog(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::WelcomeDialog) {

	ui->setupUi(this);

	ui->textBrowser->setSource(QUrl("qrc:/WelcomeDialog/acre_welcome.html"));
	ui->textBrowser->setOpenExternalLinks(true);
}
WelcomeDialog::~WelcomeDialog() {
	delete ui;
}
