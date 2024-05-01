import 'package:flutter/material.dart';

class CarbonFootprintCalculator extends StatefulWidget {
  const CarbonFootprintCalculator({Key? key}) : super(key: key);

  @override
  _CarbonFootprintCalculatorState createState() =>
      _CarbonFootprintCalculatorState();
}

class _CarbonFootprintCalculatorState extends State<CarbonFootprintCalculator> {
  // Define the variables that will store the user's inputs
  double _carMileage = 0;
  double _carUsageTime = 0;
  double _publicTransportUsageTime = 0;
  double _flightsPerYear = 0;
  double _meatConsumption = 0;
  double _plasticUsage = 0;
  double _electricityUsage = 0;
  double _carMileageCarbonFootprint = 0;
  double _carUsageCarbonFootprint = 0;
  double _publicTransportCarbonFootprint = 0;
  double _flightsCarbonFootprint = 0;
  double _meatCarbonFootprint = 0;
  double _plasticCarbonFootprint = 0;
  double _electricityCarbonFootprint = 0;
  double _totalCarbonFootprint = 0;

  int _treesToPlant = 0;
  final double maxSliderValue = 100;
  final double maxPlasticSliderValue = 1000;
  final double maxElectricSliderValue = 500;
  final double maxMeatSliderValue = 10;

  // Function to build sliders
Widget _buildSlider(
  String label,
  double value,
  ValueChanged<double> onChanged,
  double maxSliderValue, // Max value for the slider
  {bool isMandatory = true} // Default value is true
) {
  return Card(
    elevation: 4.0,
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (isMandatory) // Conditionally add the red asterisk
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, 
                  ),
                ),
            ],
          ),
        ),
        Slider(
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
              onChanged(value); // Update the value in the onChanged handler
            });
          },
          min: 0,
          max: maxSliderValue, // Use the provided maxSliderValue
          divisions: maxSliderValue.toInt(),
          label: value.toStringAsFixed(2),
          activeColor: Colors.brown, // Set the slider color to brown
        ),
      ],
    ),
  );
}


  void _calculateCarbonFootprint() {
    _carMileageCarbonFootprint = 1 / (_carMileage * 0.25);
    _carUsageCarbonFootprint = _carUsageTime * 0.42;
    _publicTransportCarbonFootprint = _publicTransportUsageTime * 0.09;
    _flightsCarbonFootprint = _flightsPerYear * 0.24;
    _meatCarbonFootprint = _meatConsumption * 1.35;
    _plasticCarbonFootprint = _plasticUsage * 0.0011;
    _electricityCarbonFootprint = _electricityUsage * 0.6;

    _totalCarbonFootprint = (_carUsageCarbonFootprint +
            _carMileageCarbonFootprint +
            _publicTransportCarbonFootprint +
            _flightsCarbonFootprint +
            _meatCarbonFootprint +
            _plasticCarbonFootprint +
            _electricityCarbonFootprint) /
        60;

    if (_carMileage == 0 ||
        _carUsageTime == 0 ||
        _publicTransportUsageTime < 0 ||
        _flightsPerYear < 0 ||
        _meatConsumption < 0 ||
        _plasticUsage == 0 ||
        _electricityUsage == 0) {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields with valid values.'),
        ),
      );
      return;
    }

    // Calculate trees to plant based on carbon footprint
    _treesToPlant = ((_totalCarbonFootprint) / 0.1).toInt();
    setState(() {});

    // Display result dialogs
    if (_totalCarbonFootprint < 0.5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Great job!"),
            content: const Text(  
                "Your carbon footprint is less than 0.5 ton of CO2 per year."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      _treesToPlant = 1;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("You can do better!"),
            content: Text(
                "Your carbon footprint is ${_totalCarbonFootprint.toStringAsFixed(2)} tons of CO2 per year. You should plant ${_treesToPlant.toStringAsFixed(0)} trees per year to offset your carbon emissions."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carbon Footprint Calculator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_cal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              const Text(
                'Enter information using slider',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildSlider(
                'Vehicle mileage (kilometer per liter)',
                _carMileage,
                (value) => _carMileage = value,
                maxSliderValue,
                isMandatory: true,
              ),
              _buildSlider(
                'Vehicle usage time (hours per week)',
                _carUsageTime,
                (value) => _carUsageTime = value,
                maxSliderValue,
                isMandatory: true,
              ),
              _buildSlider(
                'Public transport usage time (hours per week)',
                _publicTransportUsageTime,
                (value) => _publicTransportUsageTime = value,
                maxSliderValue,
                isMandatory: false,
              ),
              _buildSlider(
                'Flights per year',
                _flightsPerYear,
                (value) => _flightsPerYear = value,
                maxSliderValue,
                isMandatory: false,
              ),
              _buildSlider(
                'Meat consumption (kilograms per week)',
                _meatConsumption,
                (value) => _meatConsumption = value,
                maxSliderValue,
                isMandatory: false,
              ),
              _buildSlider(
                'Plastic usage (grams per week)',
                _plasticUsage,
                (value) => _plasticUsage = value,
                maxPlasticSliderValue, // Use the max value for plastic usage slider
                isMandatory: true,
              ),
              _buildSlider(
                'Electricity usage (kilowatt-hours per month)',
                _electricityUsage,
                (value) => _electricityUsage = value,
                maxElectricSliderValue,
                isMandatory: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calculateCarbonFootprint,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                  backgroundColor: Colors.brown,
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    'Your carbon footprint is:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '${_totalCarbonFootprint.toStringAsFixed(2)} tons/year',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    '🌳 to plant: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    '$_treesToPlant',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
