import * as Action from '../actionTypes';

const DEFAULT_USER = {
  firstName               : null,
  lastName                : null,
  fullName                : null,
  districtName            : null,
};

export default function userReducer(state = DEFAULT_USER, action) {
  var newState = {};

  switch(action.type) {
    case Action.UPDATE_CURRENT_USER:
      newState = { ...state, ...action.user };
      break;
  }

  return { ...state, ...newState };
}
