use "linal"

trait val Action

primitive UnknownAction is Action

trait Actionable
  """
  For things which support the Controller events system
  """
  var target:(Controller tag | None) = None
  var evt:Action = UnknownAction
  
  be action(target':Controller tag, evt':Action) =>
    target = target'
    evt = evt'
  
  be performAction() =>
    match target
    | let t:Controller tag => t.action(evt)
    else None end