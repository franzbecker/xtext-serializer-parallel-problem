package org.xtext.example.mydsl.tests

import java.util.ConcurrentModificationException
import java.util.List
import java.util.stream.Collectors
import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.serializer.ISerializer
import org.junit.Test
import org.junit.runner.RunWith
import org.xtext.example.mydsl.myDsl.Model
import org.xtext.example.mydsl.myDsl.MyDslFactory

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(MyDslInjectorProvider)
class MyDslParallelSerializingTest {

	static val factory = MyDslFactory.eINSTANCE

	@Inject ISerializer serializer

	@Test
	def void serializeSingleModel() {
		// given
		val model = createModel(5)

		// when
		val result = serializer.serialize(model)

		// then
		assertEquals("model VARCHAR ( 5 )", result)
	}

	/**
	 * Fails with "No Context for Model could be found".
	 */
	@Test
	def void serializeParallel() {
		// when
		val results = serialize1000Models

		// then
		assertEquals(1000, results.size)
	}

	/**
	 * Flaky, sometimes throws an {@link ConcurrentModificationException}.
	 */
	@Test
	def void serializeParallelAfterInitialization() {
		// given
		val emptyModel = factory.createModel
		serializer.serialize(emptyModel)

		// when
		val results = serialize1000Models

		// then
		assertEquals(1000, results.size)
	}

	private def List<String> serialize1000Models() {
		val models = (1 .. 1000).map[createModel].toList
		return models.parallelStream.map[serializer.serialize(it)].collect(Collectors.toList)
	}

	private def Model createModel(int length) {
		return factory.createModel => [
			entries += factory.createVarcharType => [
				it.length = length
			]
		]
	}

}
