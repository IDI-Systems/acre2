#pragma once

#include <QDialog>

namespace Ui {
class MainWindow;
}

class MainWindow : public QDialog
{
	Q_OBJECT

public:
	explicit MainWindow(QWidget *parent = 0);
	~MainWindow();

	void _close();

	void commit_volumes();

protected slots:
	void accept();
	void reject();

	void on_premixGlobalVolumeSlider_sliderMoved();
	void on_globalVolumeSlider_sliderMoved();

	void on_boxEnablePosition_stateChanged(int);
	void on_boxEnableRadioFilter_stateChanged(int);
	void on_boxEnableUnmuteClients_stateChanged(int);

	void on_buttonReset_clicked();
	void on_buttonHelp_clicked();
	void on_buttonAbout_clicked();

private:
	Ui::MainWindow *ui;
				
};