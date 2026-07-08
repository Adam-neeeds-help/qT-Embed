#pragma once

#include <QObject>
#include <QStringList>
#include <QList>
#include <QSerialPortInfo>

// Lets the user override which serial port the Flipper is connected on, instead
// of relying solely on USB-serial-number auto-detection. Index 0 means "Auto".
// Exposed to QML as the "SerialPorts" singleton.
class SerialPortController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList ports READ ports NOTIFY portsChanged)
    Q_PROPERTY(int selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY selectedIndexChanged)

    SerialPortController(QObject *parent = nullptr);

public:
    static SerialPortController *instance();

    QStringList ports() const;
    int selectedIndex() const;
    void setSelectedIndex(int index);

    Q_INVOKABLE void refresh();

    // The manually chosen port, or a null QSerialPortInfo when auto-detection
    // should be used. Consulted by the device-info helper.
    QSerialPortInfo overridePort() const;

signals:
    void portsChanged();
    void selectedIndexChanged();

private:
    QList<QSerialPortInfo> m_ports;
    int m_selectedIndex; // 0 = auto, otherwise m_ports[index - 1]
};

#define globalSerialPorts (SerialPortController::instance())
