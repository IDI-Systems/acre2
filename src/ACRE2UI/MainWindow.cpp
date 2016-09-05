#include "MainWindow.hpp"
#include "ui_MainWindow.h"

#include "AboutDialog.hpp"
#include "WelcomeDialog.hpp"

#include "Log.h"
#include "AcreSettings.h"

void MainWindow::commit_volumes() {
	//MessageBoxA(NULL, " ACCEPT", "ACCEPT", NULL);
	
	float globalVolume = 1.0f;
	float premixGlobalVolume = 1.0f;

	globalVolume = static_cast<float>(ui->globalVolumeSlider->value()) * 0.01f;
	premixGlobalVolume = static_cast<float>(ui->premixGlobalVolumeSlider->value()) * 0.01f;

	// Apply the settings
	CAcreSettings::getInstance()->setGlobalVolume(globalVolume);
	CAcreSettings::getInstance()->setPremixGlobalVolume(premixGlobalVolume);
}

void MainWindow::accept() {
	this->commit_volumes();

	CAcreSettings::getInstance()->save();

	this->_close();
}

void MainWindow::reject() {
	//MessageBoxA(NULL, "REJECT", "REJECT", NULL);
	// Reload the settings
	//CAcreSettings::getInstance()->load();

	this->_close();
}

void MainWindow::_close() {
	this->close();

	this->deleteLater();

}

void MainWindow::on_buttonHelp_clicked() {
	WelcomeDialog *welcomeDialog = new WelcomeDialog(this);
	welcomeDialog->show();
}
void MainWindow::on_buttonAbout_clicked() {
	AboutDialog *aboutDialog = new AboutDialog(this);
	aboutDialog->show();
}

void MainWindow::on_boxEnablePosition_stateChanged(int state) {
	if (state == Qt::Checked) {
		CAcreSettings::getInstance()->setDisablePosition(false);
	} else {
		CAcreSettings::getInstance()->setDisablePosition(true);
	}
}
void MainWindow::on_boxEnableRadioFilter_stateChanged(int state) {
	if (state == Qt::Checked) {
		CAcreSettings::getInstance()->setDisableRadioFilter(false);
	} else {
		CAcreSettings::getInstance()->setDisableRadioFilter(true);
	}
}
void MainWindow::on_boxEnableUnmuteClients_stateChanged(int state) {
	if (state == Qt::Checked) {
		CAcreSettings::getInstance()->setDisableUnmuteClients(false);
	}
	else {
		CAcreSettings::getInstance()->setDisableUnmuteClients(true);
	}
}
void MainWindow::on_globalVolumeSlider_sliderMoved() {
	this->commit_volumes();
}
void MainWindow::on_premixGlobalVolumeSlider_sliderMoved() {
	this->commit_volumes();
}
void MainWindow::on_buttonReset_clicked() {
	ui->globalVolumeSlider->setValue(100);
	ui->premixGlobalVolumeSlider->setValue(100);

	CAcreSettings::getInstance()->setGlobalVolume(1.0f);
	CAcreSettings::getInstance()->setPremixGlobalVolume(1.0f);
}

MainWindow::MainWindow(QWidget *parent) :
	QDialog(parent),
	ui(new Ui::MainWindow) {

	ui->setupUi(this);

	float globalVolume = 1.0f;
	float premixGlobalVolume = 1.0f;
	bool disableUnmuteClients = false;

	globalVolume = CAcreSettings::getInstance()->getGlobalVolume() * 100.0f;
	premixGlobalVolume = CAcreSettings::getInstance()->getPremixGlobalVolume()  * 100.0f;
	disableUnmuteClients = CAcreSettings::getInstance()->getDisableUnmuteClients();

	//LOG("Config Dialog Opened: %f,%f", globalVolume, premixGlobalVolume);

	ui->globalVolumeSlider->setSliderPosition(globalVolume);
	ui->premixGlobalVolumeSlider->setSliderPosition(premixGlobalVolume);

	ui->globalVolumeSlider->setValue(globalVolume);
	ui->premixGlobalVolumeSlider->setValue(premixGlobalVolume);
	ui->boxEnableUnmuteClients->setChecked(!disableUnmuteClients);

#ifdef _DEBUG
	//ui->tabDebug->setTabEnabled(true);
	ui->boxEnablePosition->setEnabled(true);
	ui->boxEnableRadioFilter->setEnabled(true);
#endif

}
MainWindow::~MainWindow() {
	delete ui;
}

