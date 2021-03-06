/*
 * generated by Xtext 2.10.0
 */
package org.xtext.example.mydsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.xtext.example.mydsl.myDsl.Model

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(MyDslInjectorProvider)
class MyDslParsingTest {

	@Inject ParseHelper<Model> parseHelper
	@Inject extension ValidationTestHelper

	@Test
	def void loadModel() {
		// given
		val entry = '''
			model
			VARCHAR (5)
			CHARACTER VARYING (10)
			CHAR VARYING (15)
		'''

		// when
		val result = parseHelper.parse(entry)

		// then
		assertNotNull(result)
		result.assertNoErrors
		assertEquals(3, result.entries.size)
	}

}
