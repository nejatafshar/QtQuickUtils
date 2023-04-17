
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

SpinBox {
    property int decimals: 2
    property real realValue: 0.0
    property real realFrom: 0.0
    property real realTo: 99.0
    property real realStepSize: 1.0
    property real factor: 10 ** decimals

    onRealValueChanged: {
        value = realValue * factor
    }
    onValueChanged: {
        realValue = value / factor
    }
    onFactorChanged: {
        value = realValue * factor
    }

    stepSize: realStepSize * factor
    value: 0.0
    from: realFrom * factor
    to: realTo * factor
    editable: true
    validator: DoubleValidator {
        bottom: realFrom * factor
        top: realTo * factor
    }

    textFromValue: function (value, locale) {
        return parseFloat(value * 1.0 / factor).toFixed(decimals)
    }
    valueFromText: function (text, locale) {
        return parseFloat(text) * factor
    }
}
