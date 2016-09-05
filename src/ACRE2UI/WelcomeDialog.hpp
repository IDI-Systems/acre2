#pragma once

#include <QDialog>

namespace Ui {
class WelcomeDialog;
}

class WelcomeDialog : public QDialog
{
    Q_OBJECT

public:
    explicit WelcomeDialog(QWidget *parent = 0);
    ~WelcomeDialog();
private:
    Ui::WelcomeDialog *ui;
                
};