#ifndef QTREEMODEL_H
#define QTREEMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QJsonArray>
#include <QtQml/qqml.h>
#include "stdafx.h"

/**
 * @brief The QTreeNode class
 */
class QTreeNode : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString key READ key CONSTANT)
    Q_PROPERTY(QString title READ title CONSTANT)
    Q_PROPERTY(int depth READ depth CONSTANT)
    Q_PROPERTY(bool isExpanded READ isExpanded CONSTANT)
    Q_PROPERTY(bool checked READ checked CONSTANT)
public:
    explicit QTreeNode(QObject *parent = nullptr);
    Q_INVOKABLE QString key(){return _key;};
    Q_INVOKABLE QString title(){return _title;};
    Q_INVOKABLE int depth(){return _depth;};
    Q_INVOKABLE bool isExpanded(){return _isExpanded;};
    Q_INVOKABLE bool hasChildren(){ return !_children.isEmpty();};
    Q_INVOKABLE bool hasNextNodeByIndex(int index){
        QTreeNode* p = this;
        for(int i=0;i<(_depth - index -1);i++){
            p = p->_parent;
        }
        if(p->_parent->_children.indexOf(p) == p->_parent->_children.count()-1){
            return false;
        }
        return true;
    }
    Q_INVOKABLE bool checked(){
        if(!hasChildren()){
            return _checked;
        }
        foreach (auto item, _children) {
            if(!item->checked()){

                return false;
            }
        }
        return true;
    };
    Q_INVOKABLE bool hideLineFooter(){
        if(_parent){
            auto childIndex =  _parent->_children.indexOf(this);
            if(childIndex==_parent->_children.count()-1){
                return true;
            }
            if(_parent->_children.at(childIndex+1)->hasChildren()){
                return true;
            }
            return false;
        }
        return false;
    };
    bool isShown(){
        auto p = _parent;
        while (p) {
            if(!p->_isExpanded){
                return false;
            }
            p = p->_parent;
        }
        return true;
    }
public:
    QString _key="";
    QString _title="";
    int _depth=0;
    bool _checked = false;
    bool _isExpanded=true;
    QList<QTreeNode*> _children;
    QTreeNode* _parent = nullptr;
};

class QTreeModel : public QAbstractItemModel
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int,dataSourceSize)
    Q_PROPERTY_AUTO(QList<QTreeNode*>,selectionModel)
    QML_NAMED_ELEMENT(QTreeModel)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    explicit QTreeModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    QModelIndex parent(const QModelIndex &child) const override;
    QModelIndex index(int row, int column,const QModelIndex &parent = QModelIndex()) const override;

    Q_INVOKABLE void removeRows(int row,int count);
    Q_INVOKABLE void insertRows(int row,QList<QTreeNode*> data);
    Q_INVOKABLE QObject* getRow(int row);
    Q_INVOKABLE void setData(QList<QTreeNode*> data);
    Q_INVOKABLE void setDataSource(QList<QMap<QString,QVariant>> data);
    Q_INVOKABLE void collapse(int row);
    Q_INVOKABLE void expand(int row);
    Q_INVOKABLE void dragAndDrop(int dragIndex,int dropIndex,bool isDropTopArea);
    Q_INVOKABLE QTreeNode* getNode(int row);
    Q_INVOKABLE void refreshNode(int row);
    Q_INVOKABLE void checkRow(int row,bool checked);
    Q_INVOKABLE bool hitHasChildrenExpanded(int row);
    Q_INVOKABLE void allExpand();
    Q_INVOKABLE void allCollapse();
private:
    QList<QTreeNode*> _rows;
    QList<QTreeNode*> _dataSource;
    QTreeNode* _root = nullptr;
};

#endif // QTREEMODEL_H
