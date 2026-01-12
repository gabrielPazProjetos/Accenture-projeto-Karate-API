// runner basico para facilitar os testes da pasta features
package runners;

import com.intuit.karate.junit5.Karate;

public class AllTests {

    @Karate.Test
    Karate runAllFeatures() {
        // roda todas as features que estao dentro da pasta features do projeto
        return Karate.run("classpath:features").relativeTo(getClass());
    }
}

