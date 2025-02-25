#ifndef SETTINGSHELPER_H
#define SETTINGSHELPER_H

#include <QtCore/qobject.h>
#include <QtQml/qqml.h>
#include <QSettings>
#include <QScopedPointer>
#include <QFileInfo>
#include <QCoreApplication>
#include <QDir>
#include "dev/singleton.h"

class SettingsHelper : public QObject, public Singleton<SettingsHelper>
{
    Q_OBJECT

private:
    explicit SettingsHelper(QObject* parent = nullptr);
    friend class Singleton<SettingsHelper>; // permit singleton access into protected

public:
    ~SettingsHelper() override;
    void init(char *argv[]);

    Q_INVOKABLE void saveDarkMode(int darkModel) { save("darkMode", darkModel); }
    Q_INVOKABLE int getDarkMode() { return get("darkMode", QVariant(0)).toInt(); }

    Q_INVOKABLE void saveUseSystemAppBar(bool useSystemAppBar) { save("useSystemAppBar", useSystemAppBar); }
    Q_INVOKABLE bool getUseSystemAppBar() { return get("useSystemAppBar", QVariant(false)).toBool(); }

    Q_INVOKABLE void saveLanguage(QString language) { save("language", language); }
    Q_INVOKABLE QString getLanguage() { return get("language", QVariant("ro_RO")).toString(); }

private:
    void save(const QString& key, QVariant val);
    QVariant get(const QString& key, QVariant def = {});

private:
    QScopedPointer<QSettings> m_settings;
};

#endif // SETTINGSHELPER_H
