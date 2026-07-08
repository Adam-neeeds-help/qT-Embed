#include "serialportcontroller.h"

SerialPortController::SerialPortController(QObject *parent):
    QObject(parent),
    m_selectedIndex(0)
{
    refresh();
}

SerialPortController *SerialPortController::instance()
{
    static auto *inst = new SerialPortController();
    return inst;
}

void SerialPortController::refresh()
{
    m_ports = QSerialPortInfo::availablePorts();

    if(m_selectedIndex > m_ports.size()) {
        setSelectedIndex(0);
    }

    emit portsChanged();
}

QStringList SerialPortController::ports() const
{
    QStringList list;
    list << QStringLiteral("Auto (detect)");

    for(const auto &p : m_ports) {
        const auto label = p.description().isEmpty()
                ? p.portName()
                : QStringLiteral("%1 - %2").arg(p.portName(), p.description());
        list << label;
    }

    return list;
}

int SerialPortController::selectedIndex() const
{
    return m_selectedIndex;
}

void SerialPortController::setSelectedIndex(int index)
{
    if(index == m_selectedIndex) {
        return;
    }

    m_selectedIndex = index;
    emit selectedIndexChanged();
}

QSerialPortInfo SerialPortController::overridePort() const
{
    const int i = m_selectedIndex - 1; // index 0 is "Auto"
    if(i >= 0 && i < m_ports.size()) {
        return m_ports.at(i);
    }
    return QSerialPortInfo();
}
