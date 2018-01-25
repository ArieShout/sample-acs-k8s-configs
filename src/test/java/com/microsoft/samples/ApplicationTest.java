package com.microsoft.samples;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Unit tests for {@link Application}.
 */
public class ApplicationTest {
    @Test
    public void testHome() {
        String msg = new Application().home();
        assertEquals("Hello, Societe Generale!", msg);
    }
}
