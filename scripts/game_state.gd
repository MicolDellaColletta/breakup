extends Node

var answered_phone: bool = false
var rules_broken: Array[String] = []

func break_rule(rule: String) -> void:
	if not rules_broken.has(rule):
		rules_broken.append(rule)
