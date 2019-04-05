import { expect } from 'chai';
import React from 'react';
import { shallow } from 'enzyme';  
import TextInput from './TextInput';

describe('TextInput', () => { 
    describe('state.visited', () => { 
        const assertVisitedWhen = (visited, action = (wrapper) => {}) => {
            const wrapper = shallow(<TextInput />);
            action(wrapper);
            const actual = wrapper.state('visited');
            expect(actual).to.be[visited];
        }
        
        it('should default to false', () => {
            assertVisitedWhen(false);
        });
        
        it('should be true when input is changed to Hello', () => {
            assertVisitedWhen(true, wrapper => wrapper.find('input').simulate('change', { target: { value: 'Hello' } }));
        });
        
        it('should be true after multiple onBlur event', () => {
            assertVisitedWhen(true, wrapper => wrapper.find('input').simulate('blur').simulate('blur'))
        });
        
        it('should be true after onBlur event', () => {
            assertVisitedWhen(true, wrapper => wrapper.find('input').simulate('blur'))
        });
    });
    
    describe('(.form-group) .has-error', () => { 
        const assertPresenceWhen = (present, {valueValid, visited}) => {
            const wrapper = shallow(<TextInput isValid={() => valueValid} />);
            wrapper.setState({visited});
            
            const actual = wrapper.find('.form-group')
                                  .hasClass('has-error');
            expect(actual).to.equal(present);
        }
        
        it('is absent when value is invalid and TextInput has not been visited', () => {
            assertPresenceWhen(false, { valueValid: false, visited: false});
        });
        
        it('is present when value is invalid and TextInput has not been visited', () => {
            assertPresenceWhen(true, { valueValid: false, visited: true});
        });
        
        it('is absent when value is valid and TextInput has been visited', () => {
            assertPresenceWhen(false, { valueValid: true, visited: true});
        });
    });
});
