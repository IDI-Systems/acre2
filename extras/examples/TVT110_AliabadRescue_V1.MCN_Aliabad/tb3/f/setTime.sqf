private ["_timeParam", "_hours", "_minutes"];

_timeParam = _this select 0;


if ( _timeParam == 9999 ) then 
{
	_hours = floor(random(24));
	_minutes = floor(random(60));
} else
{
	_hours = floor(_timeParam / 100);
	_minutes = _timeParam % 100;
};

setDate[(date select 0),(date select 1),(date select 2), _hours, _minutes]; 

true // ret
